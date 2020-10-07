# create iam user(s) with full s3 permissions
resource "aws_iam_user" "iam_user_s3_full_access" {
  count         = local.count_iam_user_s3_full_names
  name          = element(var.iam_user_s3_full_names, count.index)
  force_destroy = true
}

# attach s3 full access policy to user(s): iam_user_s3_full_access
resource "aws_iam_user_policy_attachment" "attach_s3_full_access" {
  count      = local.count_iam_user_s3_full_names
  user       = element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)
  policy_arn = aws_iam_policy.iam_policy_s3_all[0].arn
}

# create login profile for users with s3 full permissions 
resource "aws_iam_user_login_profile" "s3_full_login" {
  count   = local.count_iam_user_s3_full_names
  user    = element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)
  pgp_key = base64encode(file(var.pgp_keyname))
}

# create iam user(s) with s3 list, delete permissions
resource "aws_iam_user" "iam_user_s3_list_delete_access" {
  count         = local.count_iam_user_s3_list_delete_names
  name          = element(var.iam_user_s3_list_delete_names, count.index)
  force_destroy = true
}

# attach s3 list delete access policy to user(s): iam_user_s3_list_delete
resource "aws_iam_user_policy_attachment" "attach_s3_list_delete_access" {
  count = local.count_iam_user_s3_list_delete_names
  user = element(
    aws_iam_user.iam_user_s3_list_delete_access.*.name,
    count.index,
  )
  policy_arn = aws_iam_policy.iam_policy_s3_list_delete[0].arn
}

# create login profile for users with s3 list, delete permissions
resource "aws_iam_user_login_profile" "s3_list_delete_login" {
  count = local.count_iam_user_s3_list_delete_names
  user = element(
    aws_iam_user.iam_user_s3_list_delete_access.*.name,
    count.index,
  )
  pgp_key = base64encode(file(var.pgp_keyname))
}

# create iam user(s) with s3 get, delete permissions
resource "aws_iam_user" "iam_user_s3_get_delete_access" {
  count         = local.count_iam_user_s3_get_delete_names
  name          = element(var.iam_user_s3_get_delete_names, count.index)
  force_destroy = true
}

# attach s3 get delete access policy to user(s): iam_user_s3_get_delete
resource "aws_iam_user_policy_attachment" "attach_s3_get_delete" {
  count = local.count_iam_user_s3_get_delete_names
  user = element(
    aws_iam_user.iam_user_s3_get_delete_access.*.name,
    count.index,
  )
  policy_arn = aws_iam_policy.iam_policy_s3_get_delete[0].arn
}

