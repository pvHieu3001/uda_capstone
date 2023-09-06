docker build -t uda-capstone-green-app .

dockerpath=johnwick98/uda-capstone-green-app

docker tag uda-capstone-green-app $dockerpath

docker push $dockerpath:latest