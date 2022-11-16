# [Voltar](../README.md)

### Workspace
Lets create a workspace for dev.
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
```
---
### Resource

[Resource Block Syntax](https://www.terraform.io/language/resources/syntax)
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```
- resource: block type
- aws_instance: the resource type
- example: local name or alias
- ami: the resource argument
- instance_type: the resource argument

---
[Resource Behavior](https://www.terraform.io/language/resources/behavior)

---
### Variables
[Input Variables](https://www.terraform.io/language/values)

Parameters for a Terraform module, so users can customize behavior without editing the source.
```hcl
variable "availability_zone_names" {
  description = "A list of availability zones names."
  type    = list(string)
  default = ["us-west-1a"]
}
```
Variable declarations:
```hcl
default - A default value which then makes the variable optional.
type - This argument specifies what value types are accepted for the variable.
description - This specifies the input variable's documentation.
validation - A block to define validation rules, usually in addition to type constraints.
sensitive - Limits Terraform UI output when the variable is used in configuration.
nullable - Specify if the variable can be null within the module.
```
---

[Output Values](https://www.terraform.io/language/values)

Return values for a module.
```hcl
output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}
```
---

[Local Values](https://www.terraform.io/language/values)

Convenience feature for assigning a short name to an expression.
```hcl
locals {
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}
```
---

### Resource Tagging
[Tags Syntax](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging)

These arbitrary key-value pairs can be utilized for billing, ownership, automation, access control, and many other use cases.
```hcl
resource "aws_vpc" "example" {
  # ... other configuration ...
  tags = {
    Environment = var.tag_environment
    Environment_Type = "${var.tag_name}-CloudFront"
    Environment_Name = local.tag_environment_name[var.env_name]
    Name        = "devops-app-${var.env_name}"
    Owner = var.tag_name
  }
}
```

---
This repository will create the following resources:
- S3 Bucket
- CloudFront Distribution

```bash
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

---
Commands:
```bash
terraform state list
terraform state list -module=module-one
terraform state rm aws_s3_bucket_object.current
terraform plan -var="varnew=123"
terraform plan -target=aws_iam_role.ecs_task_role
terraform plan -out sc.tfplan
terraform apply sc.tfplan
terraform apply sc.tfplan -auto-approve
terraform destroy -auto-approve
```