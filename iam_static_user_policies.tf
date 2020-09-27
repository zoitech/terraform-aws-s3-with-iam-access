# iam policy for full permission users 
resource "aws_iam_policy" "iam_policy_s3_all" {
  count       = local.count_iam_user_s3_full_names
  name        = "${aws_s3_bucket.s3_bucket.bucket}-${element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)}-s3-full-policy"
  path        = "/"
  description = "Grants ${element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)} full permissions for S3 bucket ${aws_s3_bucket.s3_bucket.bucket}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "${aws_s3_bucket.s3_bucket.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "${aws_s3_bucket.s3_bucket.arn}",
                "${aws_s3_bucket.s3_bucket.arn}/*"
            ]
        }
    ]
}
EOF

}

# iam policy for list delete permission users
resource "aws_iam_policy" "iam_policy_s3_list_delete" {
  count = local.count_iam_user_s3_list_delete_names
  name = "${aws_s3_bucket.s3_bucket.bucket}-${element(
    aws_iam_user.iam_user_s3_list_delete_access.*.name,
    count.index,
  )}-s3-list-delete-policy"
  path = "/"
  description = "Grants ${element(
    aws_iam_user.iam_user_s3_list_delete_access.*.name,
    count.index,
  )} list/delete permissions for S3 bucket ${aws_s3_bucket.s3_bucket.bucket}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListObjects",
        "s3:DeleteObject",
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.s3_bucket.arn}/*"
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.s3_bucket.arn}"
    }
  ]
}
EOF

}

# iam policy for get delete permission users
resource "aws_iam_policy" "iam_policy_s3_get_delete" {
  count = local.count_iam_user_s3_get_delete_names
  name = "${aws_s3_bucket.s3_bucket.bucket}-${element(
    aws_iam_user.iam_user_s3_get_delete_access.*.name,
    count.index,
  )}-s3-list-delete-policy"
  path = "/"
  description = "Grants ${element(
    aws_iam_user.iam_user_s3_get_delete_access.*.name,
    count.index,
  )} get/delete permissions for S3 bucket ${aws_s3_bucket.s3_bucket.bucket}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.s3_bucket.arn}/*"
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.s3_bucket.arn}"
    }
  ]
}
EOF

}

