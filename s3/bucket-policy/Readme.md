## create bucket

```sh
aws s3api create-bucket --bucket chima-s3-bucket-v1 \
--create-bucket-configuration LocationConstraint=eu-north-1
```

## create a object
```sh
echo "It is fun learning Cloud" > learncloud.txt
aws s3api put-object --bucket chima-s3-bucket-v1 --key cloudlearn.txt --body learncloud.txt
```

## create bucket access policy 
```sh
aws s3api put-bucket-policy --bucket chima-s3-bucket-v1 --policy file://policy.json
```

## clean up
```sh
aws s3 rm s3://chima-s3-bucket-v1/cloudlearn.txt
aws s3 rb s3://chima-s3-bucket-v1
```