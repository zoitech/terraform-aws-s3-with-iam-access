# create standard iam user(s) based on number of names in variable "iam_user_names_s3_standard"
resource "aws_iam_user" "standard_user" {
  count = "${local.count_standard_user}"
  name  = "${element(var.iam_user_s3_standard_names, count.index)}"
}

# attach standard user policies to standard users 
resource "aws_iam_user_policy_attachment" "user-attachment" {
  count      = "${local.count_standard_user}"
  user       = "${element(aws_iam_user.standard_user.*.name, count.index)}"
  policy_arn = "${element(aws_iam_policy.iam_policy_standard_user.*.arn, count.index)}"
}