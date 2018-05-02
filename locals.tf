locals {
  #IAM static users 
  count_iam_user_s3_full_names        = "${var.iam_user_s3_full ? "${length(var.iam_user_s3_full_names)}" :0 }"
  count_iam_user_s3_list_delete_names = "${var.iam_user_s3_list_delete ? "${length(var.iam_user_s3_list_delete_names)}" :0 }"
  count_iam_user_s3_get_delete_names  = "${var.iam_user_s3_get_delete ? "${length(var.iam_user_s3_get_delete_names)}" :0 }"

  #IAM standard users
  count_standard_user = "${length(var.iam_user_s3_standard_names)}"
}