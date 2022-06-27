pipeline {
    environment {
    registryCredential = 'dockerhub'
    DOCKER_IMAGE_NAME = 'litecoin-app'
    TAG_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    CLUSTER_NAME='eks-cluster-dev'
    DEPLOYMENT_NAME="litecoin"
    UPDATED_IMAGE_NAME = "${BUILD_NUMBER}"
    }
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
         stage('Clone repository') { 
            steps { 
                git([url: 'https://github.com/knonyelu/devops.git', branch: 'main'])
            }
        }

        stage('Build') { 
            steps { 
                script{
                 app = docker.build("litecoin")
                }
            }
        }
        stage('Push image') {
        steps{
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
                usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                 sh 'docker login -u ${USERNAME} -p ${PASSWORD}'
                 sh 'docker tag ${DOCKER_IMAGE_NAME} ${USERNAME}/${DOCKER_IMAGE_NAME}:${TAG_COMMIT}'
                 sh 'docker push ${USERNAME}/${DOCKER_IMAGE_NAME}:${TAG_COMMIT}'
                 script {
                    UPDATED_IMAGE_NAME = "${USERNAME}/${DOCKER_IMAGE_NAME}:${TAG_COMMIT}"
                 }
                 sh "echo Updated image name is: ${UPDATED_IMAGE_NAME}"
               }
        }
        }
        stage('Deploy'){
            steps {
            sh 'echo "Deploying app on EKS Cluster"'
            dir('k8s-manifests') {
                withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                        sh "aws eks update-kubeconfig --name ${CLUSTER_NAME}"
                        sh 'kubectl apply -f litecoin.yaml'
                    }
                }
        }
        }
        post {
        always {
            sh 'echo "Cleaning up"'
            sh 'docker system prune'
            sh 'docker logout'
            }
        }

    }
}
