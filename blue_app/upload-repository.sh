docker build -t uda-capstone-blue-app .

dockerpath=johnwich98/uda-capstone-blue-app

docker tag uda-capstone-blue-app $dockerpath

docker push $dockerpath:latest