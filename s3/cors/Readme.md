## create bucket 

aws s3api create-bucket --bucket chima-s3-bucket-v1 

## add a simple static html to the bucket 
aws s3api create-object --bucket chima-s3-bucket-v1 --key index.html --body index.html

#configure the s3 bucket as static website
aws s3api put-bucket-website --bucket chima-s3-bucket-v1 --website-configuration file://website.json

## Set a Public Read Bucket Policy
aws s3api put-bucket-policy --bucket chima-s3-bucket-v1 --policy file://bucket-policy.json



#this policy ensure that the site is accessible to the public 
aws s3api put-public-access-block \
    --bucket chima-s3-bucket-v1 \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=fasle,RestrictPublicBuckets=true"
## Configure CORS on Your Bucket

## Test Your CORS Settings
