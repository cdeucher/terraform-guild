resource "aws_s3_bucket" "backend" {
    bucket = "devops-corp-terraform-state"
}
resource "aws_s3_bucket_acl" "backend" {
    bucket = aws_s3_bucket.backend.id
    acl    = "private"
}
resource "aws_s3_bucket_versioning" "versioning_example" {
    bucket = aws_s3_bucket.backend.id
    versioning_configuration {
        status = "Enabled"
    }
}