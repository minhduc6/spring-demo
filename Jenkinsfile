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
                            scannerHome = tool "Sonar"
                         }
                         steps {
                           withSonarQubeEnv(credentialsId: 'token_sonar', installationName: 'Sonar') {
                                 sh "echo ======= SCANSERVER"

                                 sh '''mvn clean verify sonar:sonar -X -Dsonar.projectKey=test1 \
                                            -Dsonar.projectName='test1' \
                                            -Dsonar.host.url=http://172.30.0.4:9000\
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
                                 def qg = waitForQualityGate(webhookSecretId:'sonar-text-check') // Reuse taskId previously collected by withSonarQubeEnv
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
                       sh 'docker build -t minhduc6/spring-demo:latest .'
                     }
                   }
               stage('Deploy') {
                   steps {
                        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                        sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                        sh 'docker push minhduc6/spring-demo:latest'
                   }
               }
//         stage('Cloning our Git') {
//             steps {
//                 deleteDir()
//                 script {
//                 sh 'git config --global --add safe.directory "*"'
//                 }
//                 checkout scm
//             }
//         }
//         stage('Build App') {
//             tools {
//                 jdk "jdk" // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
//             }
//             steps {
//                 sh 'env'
//                 sh 'echo "## compile"'
//                 sh 'mvn compile'
//                 sh 'echo "## build image"'
//             //    sh 'docker build -t test/spring--boot-hello:latest .'
//             }
//         }

//         stage('Build and SonarQube Analysis') {
//                     steps {
//                         // Build the project and run SonarQube analysis
//                         sh "mvn clean verify sonar:sonar -Dsonar.projectName='PROJECT_NAME'  -Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=${SONAR_LOGIN_TOKEN}"
//                     }
//         }
//         stage('Building image') {
//             steps{
//                 script {
//                     dockerImage = docker.build registry + ":$BUILD_NUMBER"
//                 }
//             }
//         }
//         stage('Deploy image') {
//             steps{
//                 script {
//                     docker.withRegistry( '', registryCredential ) {
//                         dockerImage.push()
//                     }
//                 }
//             }
//         }
//         stage('Cleaning up') {
//             steps{
//                 sh "docker rmi $registry:$BUILD_NUMBER"
//             }
//         }
    }
}
