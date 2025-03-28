## create a bucket
```sh
aws s3 mb s3://chima-s3-bucket-v1 
```
## create a objects

```sh
echo "Hello World!" > hello.txt
aws s3 cp hello.txt s3://chima-s3-bucket-v1
```
## change stroage class

```sh
aws s3 cp hello.txt s3://chima-s3-bucket-v1 --storage-class STANDARD_IA
```
## clean up 
```sh
aws s3 rm s3://chima-s3-bucket-v1/hello.txt
aws s3 rb s3://chima-s3-bucket-v1
```