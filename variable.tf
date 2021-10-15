########################################
# variables.tf: variables for terraform to use
########################################

variable "region" {
  description = "AWS Region to build in."
  default     = "us-west-2"
}

variable "s3_bucket_name" {
  description = "S3 Bucket name (not full arn)"
}

variable "aws_access_key" {
  description = "Key for your AWS account."
}

variable "aws_secret_key" {
  description = "Secret for your AWS account."
}

variable "ami_id" {
  description = "ID for the AMI."
}

variable "instance_type" {
  description = "Instance type."
}

variable "vpc_id" {
  description = "ID for the VPC."
}

variable "cidr_block" {
  description = "IP to accept TCP traffic from."
  type        = list(string)
}

variable "aws_ec2_key" {
  description = "AWS stored key for EC2 key pair."
}
