## create a user that would assume the role

```sh
aws iam create-user --user-name sts-s3-user
aws iam create-access-key \
    --user-name sts-s3-user \
    --output table
```

## create a role and add a trust policy 
The role defines what permissions are allowed (s3 permission) and who can assume it. The trust policy specifies that your IAM user (or another principal) is allowed to assume the role

```sh
aws iam create-role \
    --role-name AssumeRole \
    --assume-role-policy-document file://trust-policy.json \
    --max-session-duration 3600
```

## attach an s3 access policy to the role

```sh
aws iam put-role-policy \
    --role-name AssumeRole \
    --policy-name s3-sts-permission \
    --policy-document file://s3-access-policy.json
```
## create s3 bucket

```sh
aws s3api create-bucket --bucket chima-s3-bucket-v1 \
--create-bucket-configuration LocationConstraint=eu-north-1
```

## add objects to bucket 

```sh
echo "Hello World!" > hello.txt
aws s3api put-object \
--bucket chima-s3-bucket-v1 \
--key hello.txt \
--body hello.txt 
```

## check who you are 

```sh
aws sts get-caller-identityls 
```

## let the IAM user assume the role 

```sh
aws sts assume-role \
    --role-arn arn:aws:iam::861276117245:role/AssumeRole \
    --role-session-name s3-permit-1 \
    --profile sts
```


## test the permission by accessing the bucket 

```sh
aws s3 ls s3://chima-s3-bucket-v1 --profile assumed-role
```


