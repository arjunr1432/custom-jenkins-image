pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
                sh 'mvn --version'
                sh 'java --version'
                sh 'flutter --version'
            }
        }
    }
}





