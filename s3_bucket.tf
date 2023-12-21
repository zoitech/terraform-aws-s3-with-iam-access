# The S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.s3_versioning_enabled ? "Enabled" : "Disabled" #default = false
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    status = var.lifecycle_rule_enabled  ? "Enabled" : "Disabled" #default = false
    id      = "test"      #required #default = ""

    filter {
      prefix  = var.lifecycle_rule_prefix  #default = whole bucket
    }


    expiration {
      days = var.lifecycle_rule_expiration #default = 0
    }

    noncurrent_version_expiration {
      noncurrent_days  = var.lifecycle_rule_noncurrent_version_expiration #default = 90
    }
  }
}