#!/bin/bash 

STACK_NAME=chima-create-bucket-stack
#creates a stack to create s3 bucket
aws cloudformation deploy \
--no-execute-changeset \
--region us-east-1 \
--template-file template.yaml \
--stack-name $STACK_NAME