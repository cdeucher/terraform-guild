# [Voltar](../README.md)

### Workspace
Lets create a workspace for dev.
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan --var-file=environments/dev.tfvars | grep -A 10 "Plan:"
```
---
### State

[Specification](https://www.terraform.io/language/state)

Terraform must store state about your managed infrastructure and configuration. 
This state is used by Terraform to map resources to your configuration.
```BASH
terraform state -h
```

### List
```BASH
terraform state list
terraform state list aws_s3_bucket_object.current
```

### List by resource id
```BASH
terraform state list -id="current/"
terraform plan --var-file=environments/dev.tfvars | grep -E "\[id=.+\]"
```

### Show
```BASH
terraform state show
terraform state show aws_s3_bucket.devops_app_bucket
```

### Move
```BASH
terraform state mv aws_s3_bucket.devops_app_bucket aws_s3_bucket.devops_app_bucket2
```

### Exclude
```BASH
terraform state rm aws_s3_bucket.devops_app_bucket2
```

### Import
```BASH
terraform import aws_instance.example i-1234567890abcdef0
terraform import -var-file environments/dev.tfvars aws_s3_bucket.devops_app_bucket "i-1234567890abcdef0"
```

### Destroy
```BASH
terraform destroy -target=ws_s3_bucket.b2b_experience_app_s3 -var-file environments/dev.tfvars
```

### Destroy
```BASH
terraform destroy -target=ws_s3_bucket.b2b_experience_app_s3 -var-file environments/dev.tfvars
```

### Taint
```BASH
terraform taint ws_s3_bucket.b2b_experience_app_s3
terraform untaint ws_s3_bucket.b2b_experience_app_s3
```

### Remote State

[Specification](https://www.terraform.io/language/state/remote-state-data)
```HCL
terraform {
  backend "s3" {
    bucket = "devops-corp-terraform-state"
    key    = "corp/devops"
    region = "us-east-1"
  }
}
```

### Migration
```BASH
terraform init -migrate-state
```
