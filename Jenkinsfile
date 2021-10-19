pipeline {
  agent { label 'master'}
  options {
    skipDefaultCheckout(true)
  }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('terraform') {
      steps {
        sh 'sudo whoami'
        sh 'sudo su'
        sh 'cp ../credentials credentials'
        sh 'cp ../config config'
        sh 'export AWS_SHARED_CREDENTIALS_FILE=/var/lib/jenkins/workspace/Android-Builder-Terraform/credentials'
        sh 'export AWS_CONFIG_FILE=/var/lib/jenkins/workspace/Android-Builder-Terraform/config'
        sh 'cp ../dev.tfvars dev.tfvars'
        sh 'terraform init'
        sh 'terraform apply -var-file="dev.tfvars" -auto-approve -no-color'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}