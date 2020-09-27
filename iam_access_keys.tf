#access keys for the standard users 
resource "aws_iam_access_key" "iam_user_standard_access" {
  count   = local.count_standard_user
  user    = element(aws_iam_user.standard_user.*.name, count.index)
  pgp_key = base64encode(file(var.pgp_keyname))
}

