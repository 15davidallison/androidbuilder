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
        sh 'cp ../dev.tfvars dev.tfvars'
        sh 'terraform init'
        sh 'terraform apply -var-file="dev.tfvars -auto-approve -no-color'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}