resource "aws_s3_bucket" "news" {
  bucket        = "${var.prefix}-terraform-infra-static-pages"
  force_destroy = true

  logging {
    target_bucket = "target-bucket"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "news" {
  bucket = aws_s3_bucket.news.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "news" {
  bucket = aws_s3_bucket.news.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "news" {
  depends_on = [
    aws_s3_bucket_public_access_block.news,
    aws_s3_bucket_ownership_controls.news,
  ]

  bucket = aws_s3_bucket.news.id
  acl    = "public-read"
}


resource "aws_s3_bucket_policy" "news" {
  depends_on = [
    aws_s3_bucket_public_access_block.news,
    aws_s3_bucket_ownership_controls.news,
  ]

  bucket = aws_s3_bucket.news.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "newsBucketPolicy",
  "Statement": [
    {
      "Sid":"PublicReadGetObject",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.news.arn}/*"]
    },
    {
      "Sid": "AllowBucketAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.news.arn}"
    }
  ]
}
POLICY
}

resource "aws_kms_key" "news" {
    description = "KMS key for news service"
    deletion_window_in_days = 10
    is_enabled = true
    enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "news" {
    bucket = aws_s3_bucket.news.id

    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.news.arn
            sse_algorithm     = "aws:kms"
        }
    }
}