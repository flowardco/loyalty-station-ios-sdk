pipeline {
  agent {
    docker {
      image 'gamiphy/node-dind:10'
      args '-v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  stages {
    stage('Prepare') {
      steps {
        sh 'echo "Riyad Yahya"'
      }
    }
  }
}
