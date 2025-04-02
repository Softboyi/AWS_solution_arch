## create nacl 
aws ec2 create-network-acl \
--vpc-id vpc-72e498r854 \
--tag-specification ResourceType=network-acl,Tags='[{Key=Name,Value="my-nacl"}]'

## add rules to the nacl created [allow ssh]
aws ec2 create-network-acl-entry \
--network-acl-id acl-089f0 \
--ingress \
--rule-number 100 \
--protocol tcp \
--port-range From=22,To=22 \
--cidr-block 192.168.31.0/24 \
--rule-action allow


## to get the subnet association id
aws ec2 describe-network-acls \
    --filters Name=association.subnet-id,Values=subnet-0444422b72 \
    --query "NetworkAcls[0].Associations[?SubnetId=='subnet-2a6b72'].NetworkAclAssociationId" \
    --output text


## associate a the acl to subnet 
aws ec2 replace-network-acl-association \
--association-id aclassoc-4444472c2c0e \
--network-acl-id acl-144445e41f0