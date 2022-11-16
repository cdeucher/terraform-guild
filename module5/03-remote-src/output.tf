output "module_public_s3_buckets" {
  value = data.terraform_remote_state.db.outputs.cloudfront
}