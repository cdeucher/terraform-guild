terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}
provider "aws" {
  region = var.region
}
terraform {
   backend "s3" {
     bucket = "devops-corp-terraform-state"
     key    = "corp/devops"
     region = "us-east-1"
   }
}