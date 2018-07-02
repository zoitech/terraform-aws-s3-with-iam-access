data "aws_caller_identity" "current" {}

# Account
provider "aws" {
  region = "${var.region}"
}

# Region
variable "region" {
  description = "The AWS region to run in."
  default     = "eu-central-1"
}

# Prefix
variable "prefix" {
  description = "A prefix which is added to each resource name."
  default     = ""
}

# Suffix
variable "suffix" {
  description = "A suffix which is added to each resource name."
  default     = ""
}