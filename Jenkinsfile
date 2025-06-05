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

        stage('Git Clone') {
            steps {
                sh 'git clone --branch main https://github.com/ashrafgate/Flask-App-to-AWS-EKS-with_RDS.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('Flask-App-to-AWS-EKS/terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Outputs from Terraform') {
            steps {
                dir('Flask-App-to-AWS-EKS/terraform') {
                    script {
                        env.ECR_URI = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()
                        env.DB_HOST = sh(script: "terraform output -raw rds_endpoint", returnStdout: true).trim()

                        echo "ECR URI: ${env.ECR_URI}"
                        echo "RDS Endpoint: ${env.DB_HOST}"
                    }
                }
            }
        }

        stage('Update app.py & deployment-template.yaml') {
            steps {
                script {
                    sh """
                        sed -i "s/'host':.*/'host': '\${DB_HOST}',/" Flask-App-to-AWS-EKS/flaskapp/app.py
                    """

                    // This sed replaces the line in a robust way.
                    sh """
                        sed -i '/name: DB_HOST/{n;s|value: .*|value: "\${DB_HOST}"|}' Flask-App-to-AWS-EKS/deployment-template.yaml
                    """
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('Flask-App-to-AWS-EKS/flaskapp') {
                    script {
                        def ecrUri = env.ECR_URI
                        sh """
                            aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ecrUri}
                            docker build -t ${ecrUri}:$IMAGE_TAG .
                            docker push ${ecrUri}:$IMAGE_TAG
                        """
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                dir('Flask-App-to-AWS-EKS') {
                    script {
                        def ecrUri = env.ECR_URI
                        sh """
                            aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
                            cp deployment-template.yaml deployment.yaml
                            sed -i "s|<ECR_IMAGE_PLACEHOLDER>|${ecrUri}:$IMAGE_TAG|g" deployment.yaml
                            kubectl apply -f deployment.yaml
                            kubectl apply -f service.yaml
                        """
                    }
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
