## create bucket
```sh 
aws s3api create-bucket --bucket chima-s3-bucket-v1 \
--create-bucket-configuration LocationConstraint=eu-north-1
```

## create a AES256 key 
```sh
Customer_key=$(openssl rand -base64 32)
```

## create md5 key for integrity checks
```sh
Customer_key_md5=$(echo -n "$Customer_key" | base64 -d | openssl dgst -md5 -binary |  openssl base64)
```

## add object to bucket using the customer-provided encryption keys [SSE-C]
```sh
aws s3api put-object --bucket chima-s3-bucket-v1 \
--key hello.txt \
--body hello.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key "$Customer_key" \
--sse-customer-key-md5 "$Customer_key_md5"
```


## get the object head to verify your settings 
```sh
aws s3api head-object \
--bucket chima-s3-bucket-v1 \
--key hello.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key "$Customer_key" \
--sse-customer-key-md5 "$Customer_key_md5"
```

## download object using keys 
```sh
aws s3api get-object --bucket chima-s3-bucket-v1 \
--key hello.txt \
hello.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key "$Customer_key" \
--sse-customer-key-md5 "$Customer_key_md5"
```

