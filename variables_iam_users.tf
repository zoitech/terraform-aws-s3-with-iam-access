variable "iam_user_s3_standard" {
  description = "Enable IAM user(s) with S3 bucket full access"
  default     = false
}

variable "iam_user_s3_standard_names" {
  type        = "list"
  description = "Names of the IAM users with standard access"
  default     = []
}