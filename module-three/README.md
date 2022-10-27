# [Voltar](../README.md)

### Workspace
Lets create a workspace for dev.
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan --var-file=environments/dev.tfvars | grep -A 10 "Plan:"
```

### Modules

A Terraform module is a set of Terraform configuration files in a single directory.

[State](https://developer.hashicorp.com/terraform/tutorials/modules/module)

### What are modules for?
- Organize configuration.
- Encapsulate configuration.
- Re-use configuration.

### Local Module Block
```HCL
module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  common_tags = local.common_tags
}
```

### Remote Module Structure
```HCL
module "s3" {
  source = "git@github.com:<user>/<repo>.git//module-three//modules//s3?ref=master"
  bucket_name = var.bucket_name
  common_tags = local.common_tags
}
```

### Using module resources
```HCL
resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = module.s3.bucket_regional_domain_name
    #...
```