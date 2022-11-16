app_name     = "app-devops"
buckets      = [
  { bucket_name="app-bucket-devops1", is_public=false},
  { bucket_name="app-bucket-devops2", is_public=true}
]
s3_origin_id = "s3OriginDevops"
cf_custom_error_response = [
  {
    error_caching_min_ttl = 0
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  },{
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
]