resource "aws_s3_bucket" "devops_app_bucket" {
  bucket = var.bucket_name
  tags = merge(
    var.common_tags, {
      Name = "S3-${var.bucket_name}"
    },
  )
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.devops_app_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "devops_app_access_block" {
  bucket = aws_s3_bucket.devops_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

resource "aws_s3_bucket_ownership_controls" "website_controls" {
  bucket = aws_s3_bucket.devops_app_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

data "aws_iam_policy_document" "devops_app_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.devops_app_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "devops_app_bucket_policy" {
  bucket = aws_s3_bucket.devops_app_bucket.id
  policy = data.aws_iam_policy_document.devops_app_policy_document.json
}

resource "aws_s3_bucket_object" "current" {
  bucket = aws_s3_bucket.devops_app_bucket.id
  content_type = "application/x-directory"
  key    = "current/"
}

resource "aws_s3_bucket_object" "static_sync" {
  for_each = toset([ for fn in fileset("${path.module}/src", "**/*") : fn if length(regexall("^logotypes\\/r12n\\/[0-9]{14}\\.jpg$", fn)) == 0 ])

  bucket = aws_s3_bucket.devops_app_bucket.id
  key    = "current/${each.value}"
  source = "${path.module}/src/${each.value}"
  etag   = filemd5("${path.module}/src/${each.value}")
  content_type = "%{ if contains(["jpeg", ".jpg"], strrev(substr(strrev(each.value), 0, 4))) }image/jpeg%{ endif }%{ if contains(["png"], strrev(substr(strrev(each.value), 0, 3))) }image/png%{ endif }%{ if contains(["json"], strrev(substr(strrev(each.value), 0, 4))) }application/json%{ endif }%{ if contains(["apple-app-site-association"], strrev(substr(strrev(each.value), 0, 26))) }application/json%{ endif }%{ if contains(["html"], strrev(substr(strrev(each.value), 0, 4))) }text/html%{ endif }%{ if contains(["js"], strrev(substr(strrev(each.value), 0, 2))) }text/javascript%{ endif }%{ if contains(["css"], strrev(substr(strrev(each.value), 0, 3))) }text/css%{ endif }%{ if contains(["csv"], strrev(substr(strrev(each.value), 0, 3))) }text/csv%{ endif }"
}