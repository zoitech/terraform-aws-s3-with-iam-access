locals {
  #IAM static users 
  count_iam_user_s3_full_names        = length(var.iam_user_s3_full_names)
  count_iam_user_s3_list_delete_names = length(var.iam_user_s3_list_delete_names)
  count_iam_user_s3_get_delete_names  = length(var.iam_user_s3_get_delete_names)

  #IAM standard users
  count_standard_user = length(var.iam_user_s3_standard_names)
}

