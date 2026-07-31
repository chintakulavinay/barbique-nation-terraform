pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Environment') {
            steps {
                script {

                    if (env.BRANCH_NAME == 'dev') {
                        env.TF_ENV = 'dev'
                    }
                    else if (env.BRANCH_NAME == 'qa') {
                        env.TF_ENV = 'qa'
                    }
                    else if (env.BRANCH_NAME == 'main') {
                        env.TF_ENV = 'prod'
                    }
                    else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    echo "Branch Name : ${env.BRANCH_NAME}"
                    echo "Target Environment : ${env.TF_ENV}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform']
                ]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                bat 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform']
                ]) {

                    bat """
                    terraform plan ^
                    -var-file=tfvars\\%TF_ENV%.tfvars ^
                    -out=tfplan
                    """
                }
            }
        }

        stage('Production Approval') {
            when {
                expression {
                    env.TF_ENV == 'prod'
                }
            }
            steps {
                input(
                    message: 'Approve Production Deployment?',
                    ok: 'Deploy'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform']
                ]) {

                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {

        success {
            echo "Deployment completed successfully."
            echo "Environment : ${env.TF_ENV}"
        }

        failure {
            echo "Deployment failed."
        }

        always {
            cleanWs()
        }
    }
}