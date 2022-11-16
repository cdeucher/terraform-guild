output "bucket_name" {
  value = [module.public_s3[*].bucket_name]
  sensitive = true
}
output "cloudfront" {
  value = [aws_cloudfront_distribution.distribution.*.domain_name]
}