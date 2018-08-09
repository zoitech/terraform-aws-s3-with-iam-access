# create KMS keys for standard users to enable encrypted uploads 
# permission is also given to the get, delete permissioned user(s)
resource "aws_kms_key" "kmskey" {
  count       = "${local.count_standard_user}"
  description = "${element(var.iam_user_s3_standard_names, count.index)}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "${element(aws_iam_user.standard_user.*.arn, count.index)}",
            "${element(aws_iam_user.iam_user_s3_get_delete_access.*.arn, count.index)}"
          ]
        },
        "Action": ["kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt", "kms:GenerateDataKey", "kms:DescribeKey"],
        "Resource": "*"
      },
      {
        "Sid": "Allow attachment of persistent resources",
        "Effect": "Allow",
        "Principal": {
          "AWS": "${element(aws_iam_user.standard_user.*.arn, count.index)}"
        },
        "Action": ["kms:CreateGrant", "kms:ListGrants", "kms:RevokeGrant"],
        "Resource": "*",
        "Condition": {
          "Bool": {
            "kms:GrantIsForAWSResource": "true"
          }
        }
      }
    ]
}
POLICY
}

# create alias(') for the KMS key(s)
resource "aws_kms_alias" "kmskeyaliases" {
  count       = "${local.count_standard_user}"
  name          = "alias/${element(var.iam_user_s3_standard_names, count.index)}"
  target_key_id = "${element(aws_kms_key.kmskey.*.key_id, count.index)}"
}