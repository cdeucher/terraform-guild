locals {
  common_tags = {
    Application = var.app_name
  }

  # First convert the list of buckets to a map.
  buckets_map = { for i, bucket in var.buckets : tostring(i) => bucket }

  # Next create a filtered list of the keys that respectively matches the condition.
  # compact() is used to remove empty values.
  public_keys = compact([for i, bucket in local.buckets_map : bucket.is_public == true ? i : ""])
  private_keys = compact([for i, bucket in local.buckets_map : bucket.is_public == false ? i : ""])

  # Lookup the respective bucket from the buckets_map
  # lookup() retrieves the value of a single element from a map.
  public_buckets = [for key in local.public_keys : lookup(local.buckets_map, key).bucket_name]
  private_buckets = [for key in local.private_keys : lookup(local.buckets_map, key).bucket_name]

  # compact([for name in local.public_buckets : aws_s3_bucket[name].is_public ? aws_s3_bucket[name].id : ""])
}
