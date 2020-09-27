# iam access keys for full permission users 
resource "aws_iam_access_key" "iam_user_s3_full_access" {
  count   = local.count_iam_user_s3_full_names
  user    = element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)
  pgp_key = base64encode(file(var.pgp_keyname))
}

# iam access keys for list delete permission users 
resource "aws_iam_access_key" "iam_user_s3_list_delete_access" {
  count = local.count_iam_user_s3_list_delete_names
  user = element(
    aws_iam_user.iam_user_s3_list_delete_access.*.name,
    count.index,
  )
  pgp_key = base64encode(file(var.pgp_keyname))
}

# iam access keys for get delete permission users 
resource "aws_iam_access_key" "iam_user_s3_get_delete_access" {
  count = local.count_iam_user_s3_get_delete_names
  user = element(
    aws_iam_user.iam_user_s3_get_delete_access.*.name,
    count.index,
  )
  pgp_key = base64encode(file(var.pgp_keyname))
}

