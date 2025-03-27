module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.0"
  bucket = "chima-s3-bucket-v1-tf"  # Bucket name
  tags = {
    Name = "My S3 Bucket"
  }
}