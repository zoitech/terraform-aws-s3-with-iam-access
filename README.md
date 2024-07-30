# AWS S3 Bucket with IAM Access Module
Terraform module which creates an S3 bucket with varying levels of access for IAM users.

The following resources will be created:
* An S3 bucket
The following resources are optional:
* IAM User(s)
* IAM Policies
* KMS Keys
* KMS Bucket Policy

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
The argument for the region is required to specify where the resources should be created:
```hcl
region = "eu-west-1" #default = "eu-central-1"
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

#### The KMS Bucket Policy 
Setting the following variable to true, will apply the KMS bucket policy which disables unencrypted uploads and enables uploads from users which possess KMS keys (Pleae note if this variable is enabled, IAM Users are REQUIRED to be created, or the apply will fail!):
```hcl
enable_kms_bucket_policy = true #default = false
```

### IAM Bucket Management Users 

#### IAM User(s): S3 Bucket Full Permissions 
Create IAM user(s) with full S3 bucket permissions (These users receive both management console and programmatic access):
```hcl
iam_user_s3_full_names = ["superadmin1", "superadmin2"]
```
#### IAM User(s): S3 Bucket List/Delete Permissions 
Create IAM user(s) with limited administrative (list and delete) S3 bucket permissions (These users receive both management console and programmatic access):
```hcl
iam_user_s3_list_delete_names = ["admin1", "admin2"]
```
#### IAM User(s): S3 Bucket Get/Delete Permissions 
Create IAM user(s) with limited administrative (get and delete) S3 bucket permissions (These users receive only programmatic access)

Recommended as a synchronisation user:
```hcl
iam_user_s3_get_delete_names = ["sync_user", "sync_user2"]
```
### IAM Bucket Standard Users
Create IAM user(s) with their own bucket key (directory) in the S3 bucket. These users are assigned their own KMS keys which enable them to upload files in encrypted format as well as to download them and decrypt. (These users receive only programmatic access, therefore FTP client software such as CloudBerry or Cyberduck should be used):
```hcl
iam_user_s3_standard_names = ["Huey", "Dewey", "Louie"]
```

#### PGP Key 
A public PGP key (in binary format) is required for encrypting the IAM secret keys and KMS keys, as these are given in output (Please see outputs below):
```hcl
pgp_keyname = "C123654C.pgp"
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
  value = module.s3.bucket_name
}
#The ARN of the S3 bucket
output "Bucket-ARN" {
  value = module.s3.bucket_arn
}
#The users with full S3 bucket permissions
output "Superadmins" {
  value = module.s3.s3_full_user_info
}
#The users with list/delete S3 bucket permissions
output "Admins" {
  value = module.s3.s3_list_delete_user_info
}
#The users with get/delete S3 bucket permissions
output "Sync-Users" {
  value = module.s3.s3_get_delete_user_info
}
#The users with access to their own S3 bucket keys
output "User-Info" {
  value = module.s3.standard_user_info
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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.iam_user_s3_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.iam_user_s3_get_delete_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.iam_user_s3_list_delete_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.iam_user_standard_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.iam_policy_s3_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_policy_s3_get_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_policy_s3_list_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_policy_standard_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.iam_user_s3_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.iam_user_s3_get_delete_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.iam_user_s3_list_delete_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.standard_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_login_profile.s3_full_login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_user_login_profile.s3_list_delete_login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_user_policy_attachment.attach_s3_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_get_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_list_delete_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.user-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_kms_alias.kmskeyaliases](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kmskey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_object.bucket_objects](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.s3_kms_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_versioning.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [template_file.bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.bucket_policy_for_a_standard_user](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.bucket_policy_for_deny_unencrypted](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_full_user_output](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_full_user_outputs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_get_delete_user_output](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_get_delete_user_outputs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_list_delete_user_output](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_list_delete_user_outputs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.standard_user_output](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.standard_user_outputs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_kms_bucket_policy"></a> [enable\_kms\_bucket\_policy](#input\_enable\_kms\_bucket\_policy) | Disables unencrypted uploads, enables user uploads with KMS keys | `bool` | `false` | no |
| <a name="input_iam_user_s3_full_names"></a> [iam\_user\_s3\_full\_names](#input\_iam\_user\_s3\_full\_names) | Names of the IAM users with S3 bucket full access | `list(string)` | `[]` | no |
| <a name="input_iam_user_s3_get_delete_names"></a> [iam\_user\_s3\_get\_delete\_names](#input\_iam\_user\_s3\_get\_delete\_names) | Names of the IAM users with S3 bucket get/delete permissions | `list(string)` | `[]` | no |
| <a name="input_iam_user_s3_list_delete_names"></a> [iam\_user\_s3\_list\_delete\_names](#input\_iam\_user\_s3\_list\_delete\_names) | Names of the IAM users with S3 bucket list/delete permissions | `list(string)` | `[]` | no |
| <a name="input_iam_user_s3_standard_names"></a> [iam\_user\_s3\_standard\_names](#input\_iam\_user\_s3\_standard\_names) | Names of the IAM users with standard access | `list(string)` | `[]` | no |
| <a name="input_lifecycle_config_rule_id"></a> [lifecycle\_config\_rule\_id](#input\_lifecycle\_config\_rule\_id) | ID of the lifecycle configuration rule | `string` | `""` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | To enable the lifecycle rule | `bool` | `false` | no |
| <a name="input_lifecycle_rule_expiration"></a> [lifecycle\_rule\_expiration](#input\_lifecycle\_rule\_expiration) | Delete current object version X days after creation | `number` | `0` | no |
| <a name="input_lifecycle_rule_id"></a> [lifecycle\_rule\_id](#input\_lifecycle\_rule\_id) | Name of the lifecyle rule id. | `string` | `""` | no |
| <a name="input_lifecycle_rule_noncurrent_version_expiration"></a> [lifecycle\_rule\_noncurrent\_version\_expiration](#input\_lifecycle\_rule\_noncurrent\_version\_expiration) | Delete noncurrent object versions X days after creation | `number` | `90` | no |
| <a name="input_lifecycle_rule_prefix"></a> [lifecycle\_rule\_prefix](#input\_lifecycle\_rule\_prefix) | Lifecycle rule prefix. | `string` | `""` | no |
| <a name="input_pgp_keyname"></a> [pgp\_keyname](#input\_pgp\_keyname) | Public PGP key in binary format | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix which is added to each resource name. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to run in. | `string` | `"eu-central-1"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket | `string` | `""` | no |
| <a name="input_s3_lifecycle_prevent_destroy"></a> [s3\_lifecycle\_prevent\_destroy](#input\_s3\_lifecycle\_prevent\_destroy) | Prevent/allow terraform to destroy the bucket | `bool` | `false` | no |
| <a name="input_s3_versioning_enabled"></a> [s3\_versioning\_enabled](#input\_s3\_versioning\_enabled) | To enable file versioning | `bool` | `false` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | A suffix which is added to each resource name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_s3_full_user_info"></a> [s3\_full\_user\_info](#output\_s3\_full\_user\_info) | n/a |
| <a name="output_s3_get_delete_user_info"></a> [s3\_get\_delete\_user\_info](#output\_s3\_get\_delete\_user\_info) | n/a |
| <a name="output_s3_list_delete_user_info"></a> [s3\_list\_delete\_user\_info](#output\_s3\_list\_delete\_user\_info) | n/a |
| <a name="output_standard_user_info"></a> [standard\_user\_info](#output\_standard\_user\_info) | n/a |
