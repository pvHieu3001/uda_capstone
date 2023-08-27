aws cloudformation update-stack \
--stack-name uda_capstone_stack \
--template-body file://aws/jenkins-server.yml  \
--parameters file://aws/parameters.json \
--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
--region=us-east-1