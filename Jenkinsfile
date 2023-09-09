pipeline {
	agent any
	environment {
    	DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  	}
	stages {
		stage("Lint HTML") {
			steps {
				sh 'tidy -q -e ./blue_app/*.html'
				sh 'tidy -q -e ./green_app/*.html'
			}
		}

		stage("Change Permissions") {
			steps {
				sh '''
					cd ./blue_app
					chmod +x ./build-image.sh
					chmod +x ./remove-image.sh
				'''
				sh '''
					cd ./green_app
					chmod +x ./build-image.sh
					chmod +x ./remove-image.sh
				'''
			}
		}

		stage("Build Docker Images") {
			parallel {
				stage("Build Blue Image") {
					steps {
						sh 'echo " ---- Building and push to dockerhub Blue Image --- "'
						sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
						sh '''
							cd ./blue_app
							./build-image.sh
						'''					
					}
				}
				stage("Build Green Image") {
					steps {	
						sh 'echo " ---- Building and push to dockerhub Green Image --- "'
						sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
						sh '''
							cd ./green_app
							./build-image.sh
						'''
					}
				}
			}
		}
		
		stage ("Remove Docker Images") {
			parallel {
				stage("Remove Blue Image") {
					steps {
						sh 'echo " ---- Removing Blue Image --- "'
						sh './blue_app/remove-image.sh'
					}
				}
				stage("Remove Green Image") {
					steps {
						sh 'echo " ---- Removing Green Image --- "'
						sh './green_app/remove-image.sh'
					}
				}
			}
		}

		stage('Configure kubectl') {
			steps {
				withAWS(region:'us-east-1', credentials:'aws_credentials') {
					sh 'aws eks --region us-east-1 update-kubeconfig --name uda-cluster'
				}
			}
		}

		stage("Deploy Application Containers") {
			parallel {
				stage("Deploy Blue Application Container") {
					steps {
						withAWS(region:'us-east-1',credentials:'aws_credentials') {
							sh 'kubectl apply -f kubernetes/blue-controller.yml'
						}
					}
				}
				stage("Deploy Green Application Container") {
					steps {
						withAWS(region:'us-east-1',credentials:'aws_credentials') {
							sh 'kubectl apply -f kubernetes/green-controller.yml'
						}
					}
				}
			}
		}

		stage("Run Blue Application") {
			steps {
				withAWS(region:'us-east-1',credentials:'aws_credentials') {
					sh 'kubectl apply -f kubernetes/blue-service.yml'
				}
			}
		}

		stage("Blue Application") {
			steps {
				withAWS(region:'us-east-1',credentials:'aws_credentials') {
					sleep time: 1, unit: 'MINUTES'
					sh 'kubectl get nodes,deploy,svc,pod'
					sh 'kubectl get service -o wide'
					sleep time: 1, unit: 'MINUTES'
				}
			}
		}

		stage("Switch to Green Application") {
			steps {
				withAWS(region:'us-east-1',credentials:'aws_credentials') {
				}
			}
		}

		stage("Green Application") {
			steps {
				withAWS(region:'us-east-1',credentials:'aws_credentials') {
					sleep time: 1, unit: 'MINUTES'
					sh 'kubectl get nodes,deploy,svc,pod'
					sh 'kubectl get service -o wide'
				}
			}
		}
	}
}
