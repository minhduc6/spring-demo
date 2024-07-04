pipeline {
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
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'Sonar'
            }
            steps {
                withSonarQubeEnv(credentialsId: 'token_sonar', installationName: 'Sonar') {
                    sh "echo ======= SCANSERVER"
                    sh '''
                        mvn clean verify sonar:sonar -X -Dsonar.projectKey=test1 \
                        -Dsonar.projectName='test1' \
                        -Dsonar.host.url=http://172.30.0.4:9000
                    '''
                    sh 'pwd'
                }
            }
        }
        stage('QUALITY GATE') {
            steps {
                sh "echo ======= ENDING"
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate(webhookSecretId: 'sonar-text-check') // Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'Docker build -t minhduc6/spring-demo:latest .'
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "Docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh 'Docker push minhduc6/spring-demo:latest'
                }
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
    }
}
