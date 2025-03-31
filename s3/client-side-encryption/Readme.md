## create bucket 
```sh
aws s3 mb s3://chima-s3-bucket-v1
```

## clean up 
```sh
aws s3 rm s3://chima-s3-bucket-v1/hello.tx
aws s3 rb s3://chima-s3-bucket-v1
```