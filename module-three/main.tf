module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  common_tags = local.common_tags
}

module "s3_bucket" {
  source = "git@github.com:cdeucher/terraform-guild.git//module-three//modules//s3?ref=master"
  bucket_name = var.bucket_name
  common_tags = local.common_tags
}