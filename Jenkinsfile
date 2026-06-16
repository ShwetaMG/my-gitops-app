pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID = '030028381414'
        AWS_DEFAULT_REGION = 'ap-south-1'
        IMAGE_NAME = 'my-gitops-app'
        IMAGE_TAG = "${BUILD_NUMBER}" // Dynamically flags each build with its sequence number
        REGISTRY_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
    }
    
    stages {
        stage('Clone Source Code') {
            steps {
                echo 'Pulling application code from GitHub Repository...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo "Building Container Image version: ${IMAGE_TAG}"
                script {
                    // Compiles using our multi-stage Dockerfile pattern
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('Push to AWS ECR') {
            steps {
                echo 'Authenticating and uploading image to AWS Private Registry...'
                script {
                    // Uses the IAM instance profile role we attached to our EC2 server to log in securely!
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${REGISTRY_URL}"
                    
                    // Tag and Push image
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_URL}/${IMAGE_NAME}:latest"
                    sh "docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${REGISTRY_URL}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline ran successfully! Image version ${IMAGE_TAG} pushed to ECR."
        }
        failure {
            echo "Pipeline failed. Check build logs for diagnostic traces."
        }
    }
}