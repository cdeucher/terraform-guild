output "cf_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}
output "bucket_name" {
  value = module.s3.bucket_name
}