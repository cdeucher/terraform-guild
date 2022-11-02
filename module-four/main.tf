module "public_s3" {
  count = length(local.public_buckets)
  source = "./modules/s3"
  bucket_name = local.public_buckets[count.index]
  common_tags = local.common_tags
}

module "private_s3" {
  for_each = toset(local.private_buckets)
  source = "./modules/s3"
  bucket_name = "${each.key}-private"
  common_tags = local.common_tags
  depends_on = [module.public_s3]
}