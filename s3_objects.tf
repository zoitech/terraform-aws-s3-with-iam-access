resource "aws_s3_bucket_object" "bucket_objects" {
  count      = local.count_standard_user
  bucket     = var.s3_bucket_name
  key        = element(var.iam_user_s3_standard_names, count.index)
  content    = "."
  kms_key_id = element(aws_kms_key.kmskey.*.arn, count.index)
}

