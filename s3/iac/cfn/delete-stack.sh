#!/bin/bash 
STACK_NAME=chima-create-bucket-stack 
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region us-east-1