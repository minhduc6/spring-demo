pipeline {
    environment {
        registry = "tuanph2020/test"
        registryCredential = 'dockerhub_id'
        dockerImage = ''
        SONAR_HOST_URL = 'http://localhost:9000'  // Update with your SonarQube server URL
        // SONAR_LOGIN_TOKEN = credentials('squ_f2ea71f555307696657d40f5d214a097fe950a47')  // Use Jenkins credentials to securely store your SonarQube token
//         SONAR_LOGIN_TOKEN = 'squ_f2ea71f555307696657d40f5d214a097fe950a47'
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

               stage('SonarQube analysis') {
                         environment {
                            scannerHome = tool "Sonar"
                         }
                         steps {
                           withSonarQubeEnv("Sonar") {
                                 sh "echo ======= SCANSERVER"

                                sh '''${scannerHome}/bin/sonar-scanner -X -Dsonar.projectKey=demo \
                                  -Dsonar.projectName=demo \
                                  -Dsonar.projectVersion=1.0 \
                                  -Dsonar.sources=src/ \
                                  -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                                  -Dsonar.junit.reportsPath=target/surefire-reports/ \
                                  -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                                  -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''

                                 sh '''mvn clean verify sonar:sonar -Dsonar.projectKey=demo \
                                            -Dsonar.projectName='demo' \
                                            -Dsonar.host.url=https//:sonarqube:9001\
                                            -Dsonar.token=squ_6a6e199e7dc29cdf4e7f1485ed7765b8a545eee1'''

                                 sh '''mvn clean verify sonar:sonar -Dsonar.projectKey=demo \
                                            -Dsonar.projectName='demo' '''

                                 //sh 'mvn clean package sonar:sonar' //mvn clean verify sonar:sonar
                             }
                         }
                     }

               stage('Test') {
                   steps {
                       sh 'mvn test'
                   }
               }
               stage('Deploy') {
                   steps {
                       echo 'Deploying...'
                       // Add your deployment steps here
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
