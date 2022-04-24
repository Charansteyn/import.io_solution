pipeline {
	environment {
		registry = '444444000111.dkr.ecr.eu-west-2.amazonaws.com/express'
		registryCredential = 'AWS_JENKINS_CREDENTIAL'
		dockerImage = 'latest'
	}
	agent any
	stages {
		stage('Checkout Source') {
			steps {
				git url: 'https://github.com/import-io/infrastructure-engineer-technical-task.git', branch: 'master'
				sh './kubernetes/deployment.yml'
				sh './kubernetes/service.yaml'
			}
		}
	}
	stage("Build image") {
		steps {
			script {
				app = docker.build registry + ":$BUILD_NUMBER"
			}
		}
	}
	stage('Deploy App') {
		steps {
			script {
				docker.withRegistry('444444000111.dkr.ecr.eu-west-2.amazonaws.com/express', 'ecr:us-west-2:aws-credentials') {
					app.push("${env.BUILD_NUMBER}")
					app.push("latest")
				}
			}
		}
	}
}