resource "aws_cloudfront_origin_access_identity" "access_identity" {
  count = length(local.public_buckets)
  comment = "Cloud front identity for devops-app"
}

resource "aws_cloudfront_distribution" "distribution" {
  count = length(local.public_buckets)
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Some comment"
  default_root_object = "index.html"
  origin {
    domain_name = module.public_s3[count.index].bucket_regional_domain_name
    origin_id   = var.s3_origin_id
    origin_path = "/current"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_identity[count.index].cloudfront_access_identity_path
    }
  }
  dynamic "custom_error_response" {
    for_each = var.cf_custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.s3_origin_id
    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  tags = merge(
    local.common_tags, {
      Name = "CF-${module.public_s3[count.index].bucket_name}"
    },
  )
}