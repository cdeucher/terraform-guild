variable "bucket_name" {
    description = "The name of the bucket"
    default     = "123124-devops"
}
variable "common_tags" {
    description = "Common tags for all resources"
    default     = {
        "Environment" = "dev"
        "Owner"       = "devops"
    }
}