output "bucket_name" {
  value = aws_s3_bucket.devops_app_bucket.bucket
}
output "bucket_regional_domain_name" {
  value = aws_s3_bucket.devops_app_bucket.bucket_regional_domain_name
}