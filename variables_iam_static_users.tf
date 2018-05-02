variable "iam_user_s3_full" {
  description = "Enable IAM user(s) with S3 bucket full access"
  default     = false
}

variable "iam_user_s3_full_names" {
  type        = "list"
  description = "Names of the IAM users with S3 bucket full access"
  default     = []
}

variable "iam_user_s3_list_delete" {
  description = "Enable IAM user(s) with S3 bucket list/delete permissions"
  default     = false
}

variable "iam_user_s3_list_delete_names" {
  type        = "list"
  description = "Names of the IAM users with S3 bucket list/delete permissions"
  default     = []
}

variable "iam_user_s3_get_delete" {
  description = "Enable IAM user(s) with S3 bucket get/delete permissions"
  default     = false
}

variable "iam_user_s3_get_delete_names" {
  type        = "list"
  description = "Names of the IAM users with S3 bucket get/delete permissions"
  default     = []
}