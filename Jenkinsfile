pipeline {
  agent any
  options { timestamps() }

  environment {
    APP_DIR = "app"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build') {
      steps {
        dir("${APP_DIR}") {
          sh 'node -v'
          sh 'npm -v'
          sh 'npm ci'
          sh 'npm run build'
        }
      }
    }

    stage('Test') {
      steps {
        dir("${APP_DIR}") {
          sh 'npm test'
        }
      }
    }

    stage('Deploy to test') {
      steps {
        sh 'bash scripts/deploy_test.sh'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'deploy/test/**', fingerprint: true, onlyIfSuccessful: false
    }
  }
}
