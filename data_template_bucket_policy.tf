# template file for policy section: denying the unencrypted uploads
data "template_file" "bucket_policy_for_deny_unencrypted" {
  template = file(
    "${path.module}/templates/bucket_policies/bucket_policy_deny_unencrypted.json.tpl",
  )

  vars = {
    bucket-arn = aws_s3_bucket.s3_bucket.arn
  }
}

# template file for policy section: standard users
data "template_file" "bucket_policy_for_a_standard_user" {
  count = length(var.iam_user_s3_standard_names)
  template = file(
    "${path.module}/templates/bucket_policies/bucket_policy_user_template.json.tpl",
  )

  vars = {
    bucket-arn = aws_s3_bucket.s3_bucket.arn
    user-name  = element(aws_iam_user.standard_user.*.name, count.index)
    kms-key    = element(aws_kms_key.kmskey.*.key_id, count.index)
  }
}

# combine policy sections into one 
data "template_file" "bucket_policy" {
  template = <<JSON
$${policy_start}
$${deny_unencrypted_object_uploads}
$${user_policies}
$${policy_end}

JSON


  vars = {
    policy_start = file(
      "${path.module}/templates/bucket_policies/bucket_policy_start.json.tpl",
    )
    deny_unencrypted_object_uploads = data.template_file.bucket_policy_for_deny_unencrypted.rendered
    user_policies = join(
      ",\n",
      data.template_file.bucket_policy_for_a_standard_user.*.rendered,
    )
    policy_end = file(
      "${path.module}/templates/bucket_policies/bucket_policy_end.json.tpl",
    )
  }
}

