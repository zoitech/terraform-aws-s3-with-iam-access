# AWS S3 Bucket with IAM Access Module
Terraform module which creates an S3 bucket with varying levels of access for IAM users.

The following resources can be created:
* An S3 bucket
* IAM User(s)
* IAM Policies
* KMS Keys

## Usage
### Specify this Module as Source
```hcl
module "s3" {
  source = "git::https://github.com/zoitech/terraform-aws-s3-with-iam-access.git"

  # Or to specifiy a particular module version:
  source = "git::https://github.com/zoitech/terraform-aws-s3-with-iam-access.git?ref=v0.0.1"
```
### General Arguments
#### Resource Creation Location
The arguments for the account ID, VPC ID and region are required to specify where the resources should be created:
```hcl
account_id = "123456789123"
vpc_id = "vpc-ab123456"
region = "eu-west-1" #default = "eu-central-1"
```
#### PGP Key 
A public PGP key (in binary format) is required for encrypting the IAM secret keys and KMS keys, as these are given in output (Please see outputs below):
```hcl
pgp_keyname = "C123654C.pgp"
```
### S3 Bucket Arguments
#### Bucket Name 
Set the bucket name:
```hcl
s3_bucket_name = "my-s3-bucket"
```
#### Object Versioning 
Enable S3 object versioning:
```hcl
s3_versioning_enabled = true #default = false
```
#### Object Lifecycle 
Enable S3 object lifecycle for the whole bucket and specify a rule name.

Object expiration and/or previous version deletion is specified in days:
```hcl
lifecycle_rule_enabled = true #default = false
lifecycle_rule_id = "expire_objects_older_than_180_days_delete_previous_versions_older_than_90_days" #default = ""
lifecycle_rule_expiration = 180 #default = 0
lifecycle_rule_noncurrent_version_expiration = 90 #default = 90 
```

N.b. Object versioning must be enabled to expire current versions and delete previous versions of an object. 

#### Bucket Lifecycle Prevent Destroy
By default the prevent_destroy lifecycle is to "true" to prevent accidental bucket deletion via terraform.

### IAM Bucket Management Users 
#### IAM User(s): S3 Bucket Full Permissions 
Create IAM user(s) with full S3 bucket permissions (These users receive both management console and programmatic access):
```hcl
iam_user_s3_full = true #default = false
iam_user_s3_full_names = ["superadmin1", "superadmin2"]
```
#### IAM User(s): S3 Bucket List/Delete Permissions 
Create IAM user(s) with limited administrative (list and delete) S3 bucket permissions (These users receive both management console and programmatic access):
```hcl
iam_user_s3_list_delete = true #default = false
iam_user_s3_list_delete_names = ["admin1", "admin2"]
```
#### IAM User(s): S3 Bucket Get/Delete Permissions 
Create IAM user(s) with limited administrative (get and delete) S3 bucket permissions (These users receive only programmatic access)

Recommended as a synchronisation user:
```hcl
iam_user_s3_get_delete = true #default = false
iam_user_s3_get_delete_names = ["sync_user", "sync_user2"]
```
### IAM Bucket Standard Users
Create IAM user(s) with their own bucket key (directory) in the S3 bucket. These users are assigned their own KMS keys which enable them to upload files in encrypted format as well as to download them and decrypt. (These users receive only programmatic access, therefore FTP client software such as CloudBerry or Cyberduck should be used):
```hcl
iam_user_s3_standard = true #default = false
iam_user_s3_standard_names = ["Huey", "Dewey", "Louie"]
```

### Outputs 
The following outputs are possible:
* bucket_name (The name of the S3 bucket)
* bucket_arn (The ARN of the S3 bucket)
* s3_full_user_info  (The users with full S3 bucket permissions)
* s3_list_delete_user_info (The users with list/delete S3 bucket permissions)
* s3_get_delete_user_info (The users with get/delete S3 bucket permissions)
* standard_user_info (The users with access to their own S3 bucket keys)


Example usage:
```hcl
#The name of the S3 bucket
output "Bucket-Name" {
  value = "${module.s3.bucket_name}"
}
#The ARN of the S3 bucket
output "Bucket-ARN" {
  value = "${module.s3.bucket_arn}"
}
#The users with full S3 bucket permissions
output "Superadmins" {
  value = "${module.s3.s3_full_user_info}"
}
#The users with list/delete S3 bucket permissions
output "Admins" {
  value = "${module.s3.s3_list_delete_user_info}"
}
#The users with get/delete S3 bucket permissions
output "Sync-Users" {
  value = "${module.s3.s3_get_delete_user_info}"
}
#The users with access to their own S3 bucket keys
output "User-Info" {
  value = "${module.s3.standard_user_info}"
}
```

Example output:
```hcl
Admins = [
"user_name:   Admin",
"access_key:  <omitted>",
"secret_key:  <omitted>",
"password":   <omitted>"
]
Bucket-ARN = arn:aws:s3:::my-s3-bucket
Bucket-Name = my-s3-bucket
Superadmins = [
"user_name:   superadmin",
"access_key:  <omitted>",
"secret_key:  <omitted>",
"password":   <omitted>"
]
Sync-Users = [
"user_name:   sync-user",
"access_key:  <omitted>",
"secret_key:  <omitted>"
]
User-Info = [
"user_name:   Huey",
"access_key:  <omitted>",
"secret_key:  <omitted>",
"kms_key:     <omitted>",
"bucket_key: my-s3-bucket/Huey"

"user_name:   Dewey",
"access_key:  <omitted>",
"secret_key:  <omitted>",
"kms_key:     <omitted>",
"bucket_key: my-s3-bucket/Dewey"

"user_name:   Louie",
"access_key:  <omitted>",
"secret_key:  <omitted>",
"kms_key:     <omitted>",
"bucket_key: my-s3-bucket/Louie"
]
```