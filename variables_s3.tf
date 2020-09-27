variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = ""
}

variable "s3_versioning_enabled" {
  description = "To enable file versioning"
  default     = false
}

variable "lifecycle_rule_enabled" {
  description = "To enable the lifecycle rule"
  default     = false
}

variable "lifecycle_rule_id" {
  description = "Name of the lifecyle rule id."
  default     = ""
}

variable "lifecycle_rule_prefix" {
  description = "Lifecycle rule prefix."
  default     = ""
}

variable "lifecycle_rule_expiration" {
  description = "Delete current object version X days after creation"
  default     = 0
}

variable "lifecycle_rule_noncurrent_version_expiration" {
  description = "Delete noncurrent object versions X days after creation"
  default     = 90
}

variable "s3_lifecycle_prevent_destroy" {
  description = "Prevent/allow terraform to destroy the bucket"
  default     = false
}

variable "enable_kms_bucket_policy" {
  description = "Disables unencrypted uploads, enables user uploads with KMS keys"
  default     = false
}

