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
        stage('Install Sonar Scanner') {
            steps {
                sh 'apt-get update && apt-get install -y sonar-scanner'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                sh "sonar-scanner \
                -Dsonar.projectKey=${env.SONAR_PROJECT_KEY} \
                -Dsonar.sources=. \
                -Dsonar.host.url= http://sonar-stag.group18.site \
                "
                }
            }
        }
            
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: false
                }
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
        stage('Start Services with Docker Compose') {
            steps {
                script {
                    sh "docker system prune -af && docker compose down"
                    sh "docker compose -f docker-compose.yml up -d"
                }
            }
        }
    }
}
