aws cloudformation create-stack \
--stack-name uda-capstone-stack \
--template-body file://aws/jenkins-server.yml  \
--parameters file://aws/parameters.json \
--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
--region=us-east-1