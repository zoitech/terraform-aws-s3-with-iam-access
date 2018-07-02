# S3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}