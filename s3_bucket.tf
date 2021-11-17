# The S3 bucket 
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = var.s3_versioning_enabled #default = false
  }

  lifecycle_rule {
    enabled = var.lifecycle_rule_enabled #default = false
    id      = var.lifecycle_rule_id      #required #default = ""
    prefix  = var.lifecycle_rule_prefix  #default = whole bucket

    expiration {
      days = var.lifecycle_rule_expiration #default = 0
    }

    noncurrent_version_expiration {
      days = var.lifecycle_rule_noncurrent_version_expiration #default = 90
    }
  }
  #Make prevent_destroy setable with variable when terraform code has been changed to make this possible 
  #hashicorp/terraform#3116

  #lifecycle {
  #  prevent_destroy = true
  #}
}

