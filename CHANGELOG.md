## 2.0.0

ENHANCEMENTS:
* Upgraded terraform version to 0.13  [#](https://github.com/zoitech/terraform-aws-s3-with-iam-access/issues/6)

BACKWARDS INCOMPATIBILITIES / NOTES:
* Works with terraform 0.13.x

## Releases Version: 1.0.0

ENHANCEMENTS:
* Upgrade TF to version 12 

## Release Version: 0.0.2

BACKWARDS INCOMPATIBILITIES / NOTES:

* Tested with terraform v0.11.7



IMPROVEMENTS:

* N/A

BUG FIXES:

* KMS Key Alias preventing bucket creations when no KMS keys are created
* Bucket policy preventing bucket creation when no IAM users are created

## Release Version: 0.0.1

BACKWARDS INCOMPATIBILITIES / NOTES:

* Tested with terraform v0.11.7

INITIAL RELEASE:

* S3 Bucket: supports object versioning, lifecycle policy (on whole bucket) to remove object versions older than X days
* IAM Management Users: Admin, Sync
* Standard Users: User keys (directories) with KMS encryption for uploads

IMPROVEMENTS:

* N/A

BUG FIXES:

* N/A
