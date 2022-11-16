variable "app_name" {
    description = "The name of the application"
    type = string
}
variable "region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}
variable "s3_origin_id" {
    description = "The origin ID for the S3 bucket"
    type = string
}
variable "additional_tags" {
    description = "Additional resource tags"
    default     = {}
    type        = map(string)
}
variable "buckets" {
    description = "Name of the S3 bucket"
    type = list(object({
        bucket_name = string
        is_public = bool
    }))
}