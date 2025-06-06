pipeline {
    agent any

    environment {
        IMAGE_TAG    = 'latest'
        CLUSTER_NAME = 'my-flask-cluster'
        REGION       = 'ap-south-1'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Outputs from Terraform') {
            steps {
                dir('terraform') {
                    script {
                        env.ECR_URI = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()
                        def rawDbHost = sh(script: "terraform output -raw address", returnStdout: true).trim()
                        env.DB_HOST = rawDbHost.tokenize(':')[0]  // removes :3306 if present

                        echo "ECR URI: ${env.ECR_URI}"
                        echo "RDS Host: ${env.DB_HOST}"
                    }
                }
            }
        }

        stage('Update app.py & deployment-template.yaml') {
            steps {
                script {
                    // Update DB host in Flask app config
                    sh """
                        sed -i "s/'host':.*/'host': '${DB_HOST}',/" flaskapp/app.py
                    """

                    // Update DB_HOST env var in deployment YAML
                    sh """
                        sed -i '/name: DB_HOST/{n;s|value: .*|value: \"${DB_HOST}\"|}' deployment-template.yaml
                    """
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('flaskapp') {
                    script {
                        def ecrUri = env.ECR_URI
                        sh """
                            aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ecrUri
                            docker build -t $ecrUri:$IMAGE_TAG .
                            docker push $ecrUri:$IMAGE_TAG
                        """
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    def ecrUri = env.ECR_URI
                    sh """
                        aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
                        cp deployment-template.yaml deployment.yaml
                        sed -i "s|<ECR_IMAGE_PLACEHOLDER>|$ecrUri:$IMAGE_TAG|g" deployment.yaml
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    """
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed! Check the logs."
        }
        success {
            echo "✅ Pipeline completed successfully."
        }
    }
}
