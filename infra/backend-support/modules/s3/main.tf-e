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

    # logging {
    #     target_bucket = "target-bucket"
    # }
}

resource "aws_kms_key" "terraform_infra" {
    description = "KMS key for terraform state"
    deletion_window_in_days = 10
    is_enabled = true
    enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_infra" {
    bucket = aws_s3_bucket.terraform_infra.id

    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.terraform_infra.arn
            sse_algorithm     = "aws:kms"
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

resource "aws_s3_bucket_public_access_block" "terraform_infra" {
  bucket = aws_s3_bucket.terraform_infra.id
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}