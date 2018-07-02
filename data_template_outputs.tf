# template file for the S3 full permission user output
data "template_file" "s3_full_user_output" {
  count    = "${local.count_iam_user_s3_full_names}"
  template = "${file("${path.module}/templates/outputs/s3_full_users.tpl")}"

  vars {
    user-name  = "${element(aws_iam_user.iam_user_s3_full_access.*.name, count.index)}"
    access-key = "${element(aws_iam_access_key.iam_user_s3_full_access.*.id, count.index)}"
    secret-key = "${element(aws_iam_access_key.iam_user_s3_full_access.*.encrypted_secret, count.index)}"
    password   = "${element(aws_iam_user_login_profile.s3_full_login.*.encrypted_password, count.index)}"
  }
}

# combine the S3 full permission user outputs together
data "template_file" "s3_full_user_outputs" {
  template = "$${outputs}"

  vars {
    outputs = "${join("\n\n", data.template_file.s3_full_user_output.*.rendered)}"
  }
}

# template file for the S3 list/delete permission user output
data "template_file" "s3_list_delete_user_output" {
  count    = "${local.count_iam_user_s3_list_delete_names}"
  template = "${file("${path.module}/templates/outputs/s3_list_delete_users.tpl")}"

  vars {
    user-name  = "${element(aws_iam_user.iam_user_s3_list_delete_access.*.name, count.index)}"
    access-key = "${element(aws_iam_access_key.iam_user_s3_list_delete_access.*.id, count.index)}"
    secret-key = "${element(aws_iam_access_key.iam_user_s3_list_delete_access.*.encrypted_secret, count.index)}"
    password   = "${element(aws_iam_user_login_profile.s3_list_delete_login.*.encrypted_password, count.index)}"
  }
}

# combine the S3 list/delete permission user outputs together
data "template_file" "s3_list_delete_user_outputs" {
  template = "$${outputs}"

  vars {
    outputs = "${join("\n\n", data.template_file.s3_list_delete_user_output.*.rendered)}"
  }
}

# template file for the S3 get/delete permission user output
data "template_file" "s3_get_delete_user_output" {
  count    = "${local.count_iam_user_s3_get_delete_names}"
  template = "${file("${path.module}/templates/outputs/s3_get_delete_users.tpl")}"

  vars {
    user-name  = "${element(aws_iam_user.iam_user_s3_get_delete_access.*.name, count.index)}"
    access-key = "${element(aws_iam_access_key.iam_user_s3_get_delete_access.*.id, count.index)}"
    secret-key = "${element(aws_iam_access_key.iam_user_s3_get_delete_access.*.encrypted_secret, count.index)}"
  }
}

# combine the S3 list/delete permission user outputs together
data "template_file" "s3_get_delete_user_outputs" {
  template = "$${outputs}"

  vars {
    outputs = "${join("\n\n", data.template_file.s3_get_delete_user_output.*.rendered)}"
  }
}

# template file for the standard user output
data "template_file" "standard_user_output" {
  count    = "${local.count_standard_user}"
  template = "${file("${path.module}/templates/outputs/standard_users.tpl")}"

  vars {
    user-name   = "${element(aws_iam_user.standard_user.*.name, count.index)}"
    access-key  = "${element(aws_iam_access_key.iam_user_standard_access.*.id, count.index)}"
    secret-key  = "${element(aws_iam_access_key.iam_user_standard_access.*.encrypted_secret, count.index)}"
    kms-key     = "${element(aws_kms_key.kmskey.*.key_id, count.index)}"
    bucket-name = "${aws_s3_bucket.s3_bucket.id}"
  }
}

# combine the standard user outputs together
data "template_file" "standard_user_outputs" {
  template = "$${outputs}"

  vars {
    outputs = "${join("\n\n", data.template_file.standard_user_output.*.rendered)}"
  }
}