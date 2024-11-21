pipeline {
    agent any
    
    environment {
        AWS_REGION = 'ap-southeast-2'
        ECR_REPO = 'group18/devops_project'
        URL_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }
    
    stages { 
        stage('SCM Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'ecr-demo-credential']]) {                   
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${URL_REGISTRY}"
                        
                        sh "docker build -t ${URL_REGISTRY}/${ECR_REPO}:frontend ./front-end"
                        sh "docker build -t ${URL_REGISTRY}/${ECR_REPO}:cart_service ./Cart"
                        sh "docker build -t ${URL_REGISTRY}/${ECR_REPO}:product_service ./Product"
                        sh "docker build -t ${URL_REGISTRY}/${ECR_REPO}:user_service ./User"
                        

                        sh "docker push ${URL_REGISTRY}/${ECR_REPO}:frontend"
                        sh "docker push ${URL_REGISTRY}/${ECR_REPO}:cart_service"
                        sh "docker push ${URL_REGISTRY}/${ECR_REPO}:product_service"
                        sh "docker push ${URL_REGISTRY}/${ECR_REPO}:user_service"
                        
                    }
                }
            }
        }
        // stage('Prepare Docker Compose') {
        //     steps {
        //         script {
        //             sh """
        //             echo "MONGO_USERNAME=${MONGO_USERNAME}" > .env
        //             echo "MONGO_PASSWORD=${MONGO_PASSWORD}" >> .env
        //             echo "MONGO_CLUSTER=${MONGO_CLUSTER}" >> .env
        //             echo "MONGO_DBNAME=${MONGO_DBNAME}" >> .env
        //             echo "ACCESS_TOKEN=${ACCESS_TOKEN}" >> .env
        //             """
        //             sh "cat .env"
        //         }
        //     }
        // }
        
        stage('Start Services with Docker Compose') {
            steps {
                script {
                    sh "docker-compose -f docker-compose.yml up -d"
                }
            }
        }
    }
}
