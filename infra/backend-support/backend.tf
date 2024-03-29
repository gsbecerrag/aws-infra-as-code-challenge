# terraform {
#   backend "s3" {
#     bucket         = "newsnews4321-terraform-infra" # replace with your bucket name
#     key            = "/" # replace with your object key
#     region         = var.region # replace with your AWS region
#     dynamodb_table = var.table_name # replace with your DynamoDB table name
#     encrypt        = true
#   }
# }


# This file creates S3 bucket to hold terraform states
# and DynamoDB table to keep the state locks.
# resource "aws_s3_bucket" "terraform_infra" {
#   bucket = "newsnews4321-terraform-infra"
#   force_destroy = true

#   # To allow rolling back states
#   versioning {
#     enabled = true
#   }

#   # To cleanup old states eventually
#   lifecycle_rule {
#     enabled = true

#     noncurrent_version_expiration {
#       days = 90
#     }
#   }

#   tags = {
#     Name = "Bucket for terraform states of newsnews4321"
#     createdBy = "infra-newsnews4321/backend-support"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "terraform_infra" {
#   bucket = aws_s3_bucket.terraform_infra.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "terraform_infra" {
#   depends_on = [aws_s3_bucket_ownership_controls.terraform_infra]

#   bucket = aws_s3_bucket.terraform_infra.id
#   acl    = "private"
# }



# resource "aws_dynamodb_table" "dynamodb_table" {
#   name           = "newsnews4321-terraform-locks"
#   # up to 25 per account is free
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 2
#   write_capacity = 2
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "Terraform Lock Table"
#     createdBy = "infra-newsnews4321/backend-support"
#   }
# }
