resource "aws_s3_bucket" "terraform_infra" {
    bucket = var.bucket_name
    force_destroy = true

    tags = var.tags
    # To allow rolling back states
    versioning {
        enabled = true
    }

    # To cleanup old states eventually
    lifecycle_rule {
        enabled = true
        noncurrent_version_expiration {
        days = 90
        }
    }

    
}

resource "aws_s3_bucket_ownership_controls" "terraform_infra" {
    bucket = aws_s3_bucket.terraform_infra.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "terraform_infra" {
    depends_on = [aws_s3_bucket_ownership_controls.terraform_infra]

    bucket = aws_s3_bucket.terraform_infra.id
    acl    = "private"
}