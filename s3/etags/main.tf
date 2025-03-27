terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

#create bucket 

resource "aws_s3_bucket" "MyBucket" {
  bucket = "chima-terraform-bucket"

}


#creates objects 
resource "aws_s3_object" "my_object" {
    bucket = "chima-terraform-bucket"
    key = "my_object.html"
    source = "my_object_file.html"
    content_type = "text/html"
    etag = filemd5("my_object_file.html")  # this ensure that changes made in the source file is tracked by terraform
}