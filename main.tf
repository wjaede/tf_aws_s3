/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

resource "template_file" "s3policy" {
  filename = "${var.policy_template}"

  vars {
    s3_allowed_ip   = "${var.s3_allowed_ip}"
    internal_domain = "${var.internal_domain}"
  }
}

resource "aws_s3_bucket" "default" {
  bucket = "${var.bucket_name}.${var.internal_domain}"
  acl = "private"
  policy = "${template_file.s3policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}