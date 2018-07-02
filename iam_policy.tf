# iam policy for the standard users
resource "aws_iam_policy" "iam_policy_standard_user" {
  count       = "${local.count_standard_user}"
  name        = "${aws_s3_bucket.s3_bucket.bucket}-${element(aws_iam_user.standard_user.*.name, count.index)}-policy"
  path        = "/"
  description = "Grants ${element(aws_iam_user.standard_user.*.name, count.index)} download and upload access to the respective S3 folder for ${aws_s3_bucket.s3_bucket.bucket}"

  policy = <<EOF
{
 "Version":"2012-10-17",
 "Statement": [
   {
     "Sid": "AllowUserToSeeBucketListInTheConsole",
     "Action": ["s3:ListAllMyBuckets", "s3:GetBucketLocation"],
     "Effect": "Allow",
     "Resource": ["${aws_s3_bucket.s3_bucket.arn}:*"]
   },
  {
     "Sid": "AllowRootListingOfBucket",
     "Action": ["s3:ListBucket"],
     "Effect": "Allow",
     "Resource": ["${aws_s3_bucket.s3_bucket.arn}"],
     "Condition":{"StringEquals":{"s3:prefix":["${element(aws_iam_user.standard_user.*.name, count.index)}/"],"s3:delimiter":["/"]}}
    },
   {
     "Sid": "AllowListingOfUserFolder",
     "Action": ["s3:ListBucket"],
     "Effect": "Allow",
     "Resource": ["${aws_s3_bucket.s3_bucket.arn}"],
     "Condition":{"StringLike":{"s3:prefix":["${element(aws_iam_user.standard_user.*.name, count.index)}/*"]}}
   },
   {
     "Sid": "AllowAllS3ActionsInUserFolder",
     "Effect": "Allow",
     "Action": ["s3:PutObject", "s3:GetObject"],
     "Resource": ["${aws_s3_bucket.s3_bucket.arn}/${element(aws_iam_user.standard_user.*.name, count.index)}/*"]
   }
 ]
}

EOF
}