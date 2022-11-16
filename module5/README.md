# [Voltar](../README.md)

### Workspace
Lets create a workspace for dev.
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan --var-file=environments/dev.tfvars | grep -A 10 "Plan:"
```

### Dynamic Blocks

You can dynamically construct repeatable `settings` blocks inside resource, data, provider, and provisioner.
A dynamic block acts much like a for expression, but produces `nested blocks` instead of a complex typed value. 
It iterates over a given complex value, and generates a nested block for each element of that complex value.

*Overuse of dynamic blocks can make configuration hard to read and maintain, 
so we recommend using them only when you need to hide details in order to build a clean user interface for a re-usable module.

[Specification](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

```HCL
resource "aws_cloudfront_distribution" "distribution" {
  ...
  dynamic "custom_error_response" {
    for_each = var.cf_custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }
  ...
```


### Query Data Sources

Query data sources let you dynamically fetch data from APIs or other Terraform state backends.

[Specification](https://developer.hashicorp.com/terraform/language/data-sources)

```HCL
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}
output "aws_availability_zones" {
  description = "aws_availability_zones"
  value       = data.aws_availability_zones.available.names
}
```
```bash
AWS_PROFILE=profile terraform apply \
-target=data.aws_availability_zones.available \
-auto-approve \
-var-file=environments/dev.tfvars
```

### Sensitive Data

Terraform state can contain sensitive data, depending on the resources in use and your definition of "sensitive.".
The state contains resource IDs and all resource attributes. 
For resources such as databases, this may contain initial passwords.
When using local state, state is stored in plain-text JSON files.
When using remote state, state is only ever held in memory when used by Terraform. 
It may be encrypted at rest, but this depends on the specific remote state backend.

Recommendations:
If you manage any sensitive data with Terraform (like database passwords, user passwords, or private keys), treat the state itself as sensitive data.
Storing state remotely can provide better security. 
As of Terraform 0.9, Terraform does not persist state to the local disk when remote state is in use, and some backends can be configured to encrypt the state data at rest.

[Specification](https://developer.hashicorp.com/terraform/language/state/sensitive-data)

### Passwords
```HCL
variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}
output "db_password" {
  description = "Database administrator password"
  value       = var.db_password
  sensitive   = true
}

```

[Rotate AWS Secrets Manager secrets](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html)

### Secrets
```HCL
resource "random_password" "password" {
  length           = 18
  special          = true
  override_special = ""
}
resource "aws_secretsmanager_secret" "rds_password_secret" {
  name = "${var.app_name}-${var.env_name}-rds-password-secret"
}
resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.rds_password_secret.id
  secret_string = random_password.password.result
  depends_on = [random_password.password, aws_secretsmanager_secret.rds_password_secret]
}
#... TASK TEMPLATE
#"secrets": [
#  {"name": "DB_PASSWORD", "valueFrom": "${aws_secretsmanager_secret.rds_password_secret.arn}"},
#]
#...
```

### Remote State

The terraform_remote_state data source uses the latest state snapshot from a specified state backend to retrieve the root module output values from some other Terraform configuration.

[Remote State Data](https://developer.hashicorp.com/terraform/language/state/remote-state-data)

```HCL
# ... source project ...
terraform {
   backend "s3" {
     bucket = "terraform-state"
     key    = "devops"
     region = "us-east-1"
   }
}
output "recource_to_share" {
  value = aws_cloudfront_distribution.distribution.*.domain_name
}
# ... consumer project ...
data "terraform_remote_state" "db" {
  backend = "s3"
  config  = {
    bucket = "terraform-state"
    key    = "devops"
    region = "us-east-1"
  }
}
output "recource_to_consume" {
  value = data.terraform_remote_state.db.outputs.recource_to_share
}
```


```BASH
cd 01-state
terraform init
terraform apply

cd 02-src
terraform init
terraform apply -var-file=environments/dev.tfvars

cd 03-remote-state
terraform init
terraform apply
```