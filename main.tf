########################################
# main.tf: main terraform script
########################################

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "builder_sg" {
  name        = "builder_sg"
  description = "Allow access to repo and s3 bucket"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from Personal CIDR block"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Builder SG"
  }
}

# locals tags
locals {
  tags = {
    "app"         = "android-builder"
    "costcenter"  = "0000000"
    "environment" = "dev"
  }
}

resource "aws_iam_role" "android_builder_role" {
  name = "android_builder_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "android_builder"
  }
}

resource "aws_iam_role_policy" "android_builder_policy" {
  name = "android_builder_policy"
  role = aws_iam_role.android_builder_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*", "ec2:TerminateInstances"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "android_builder_profile" {
  name = "android_builder_profile"
  role = aws_iam_role.android_builder_role.name
}

data "template_file" "init" {
  template = file("build_apk.tpl")

  vars = {
    s3_bucket_name = "${var.s3_bucket_name}"
    repo_url       = "${var.repo_url}"
    app_name       = "${var.app_name}"
  }
}

resource "aws_instance" "android_build_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.android_builder_profile.name
  key_name             = var.aws_ec2_key
  security_groups      = [aws_security_group.builder_sg.name]
  user_data            = data.template_file.init.rendered
  tags                 = local.tags
}
