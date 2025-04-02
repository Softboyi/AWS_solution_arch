#!/bin/bash 

#create a vpc 
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 172.16.0.0/16 \
    --tag-specifications ResourceType=vpc,Tags='[{Key=Name,Value="MyVpc"}]' \
    --query Vpc.VpcId \
    --output text )

echo "VPC_ID: $VPC_ID"

#create a subnet on the vpc 
SUB_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 172.16.0.0/24 \
    --availability-zone eu-north-1a \
    --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="my-subnet-2"}]' \
    --query Subnet.SubnetId \
    --output text )
echo "SUBNET_ID: $SUB_ID"

#create a route table for the subnet 
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID \
--tag-specifications ResourceType=route-table,Tags='[{Key=Name,Value="my-route-tb"}]' \
--query RouteTable.RouteTableId \
--output text )
echo "RT: $RT_ID"

#link the route table with the subnets created 
aws ec2 associate-route-table \
--route-table-id $RT_ID \
--subnet-id $SUB_ID 

#create an internet gateway so the vpc can reach the internet
IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications ResourceType=internet-gateway,Tags='[{Key=Name,Value="my-inter-gateway"}]' \
    --query InternetGateway.InternetGatewayId \
    --output text )
echo "IGW_ID: $IGW_ID"

#link the internet gatewaty to a vpc 
aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID


#create a route rules in the route-tablle
aws ec2 create-route \
--route-table-id $RT_ID \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id $IGW_ID



