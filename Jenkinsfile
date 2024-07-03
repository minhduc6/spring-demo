pipeline {
    environment {
        registry = "tuanph2020/test"
        registryCredential = 'dockerhub_id'
        dockerImage = ''
        SONARQUBE_URL = 'http://172.30.0.4'  // Update with your SonarQube server URL
        SONARQUBE_TOKEN = 'squ_f2ea71f555307696657d40f5d214a097fe950a47'  // Use Jenkins credentials to securely store your SonarQube token
    }
    agent any

    tools {
        maven 'Maven'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/minhduc6/spring-demo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=your-project-key \
                        -Dsonar.host.url=${SONARQUBE_URL} \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    def qg = waitForQualityGate()
                    if (qg.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    } else {
                       echo 'Sonar Success'
                    }
                }
            }
        }
}
