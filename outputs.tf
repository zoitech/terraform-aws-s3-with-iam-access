output "s3_full_user_info" {
  value = [data.template_file.s3_full_user_outputs.rendered]
}

output "s3_list_delete_user_info" {
  value = [data.template_file.s3_list_delete_user_outputs.rendered]
}

output "s3_get_delete_user_info" {
  value = [data.template_file.s3_get_delete_user_outputs.rendered]
}

output "standard_user_info" {
  value = [data.template_file.standard_user_outputs.rendered]
}

output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

