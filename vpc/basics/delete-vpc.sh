#!/bin/bash

# Ensure AWS CLI is installed and configured
if ! command -v aws &> /dev/null
then
    echo "AWS CLI is not installed. Please install it and configure your credentials."
    exit 1
fi

# Set the VPC ID to delete
VPC_ID="$1"

if [ -z "$VPC_ID" ]; then
    echo "Usage: $0 <vpc-id>"
    exit 1
fi

# Detach and delete Internet Gateway
IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)
if [ "$IGW_ID" != "None" ]; then
    aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID"
    aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID"
    echo "Deleted Internet Gateway: $IGW_ID"
fi

# Delete Subnets
SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text)
for SUBNET_ID in $SUBNET_IDS; do
    aws ec2 delete-subnet --subnet-id "$SUBNET_ID"
    echo "Deleted Subnet: $SUBNET_ID"
done

# Delete Route Tables (excluding main route table)
RTB_IDS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[*].RouteTableId" --output text)
for RTB_ID in $RTB_IDS; do
    MAIN=$(aws ec2 describe-route-tables --route-table-ids $RTB_ID --query "RouteTables[0].Associations[0].Main" --output text)
    if [ "$MAIN" != "True" ]; then
        aws ec2 delete-route-table --route-table-id "$RTB_ID"
        echo "Deleted Route Table: $RTB_ID"
    fi
done

# Finally, delete the VPC
aws ec2 delete-vpc --vpc-id "$VPC_ID"
echo "Deleted VPC: $VPC_ID"
