data "terraform_remote_state" "db" {
  backend = "s3"
  config  = {
    bucket = "devops-corp-terraform-state"
    key    = "corp/devops"
    region = "us-east-1"
  }
}