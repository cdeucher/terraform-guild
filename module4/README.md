# [Voltar](../README.md)

### Workspace
Lets create a workspace for dev.
```bash
terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan --var-file=environments/dev.tfvars | grep -A 10 "Plan:"
```

###  Explicit dependencies

Implicit dependencies are the primary way that Terraform understands the relationships between your resources.

[Specification](https://developer.hashicorp.com/terraform/tutorials/configuration-language/dependencies#manage-explicit-dependencies)

```HCL
resource "aws_s3_bucket" "example" { }

resource "aws_instance" "example_c" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  depends_on = [aws_s3_bucket.example]
}
```


### Implicit dependencies

The most common source of dependencies is an implicit dependency between two resources or modules. 
Terraform automatically detects these dependencies and uses them to determine the order in which to create, update, or destroy resources.

[Specification](https://developer.hashicorp.com/terraform/tutorials/configuration-language/dependencies#manage-explicit-dependencies)

```HCL
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example_b" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.example_a.id
}
```

### For

The count argument replicates the given resource or module a specific number of times with an incrementing counter.
It works best when resources will be identical, or nearly so.

[Specification](https://developer.hashicorp.com/terraform/language/expressions/for)

`[for <ITEM> in <LIST> : <OUTPUT>]

```HCL
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
resource "aws_instance" "server" {
  # Create one instance for each subnet
  count = length(["id-1","id-2"])
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[count.index]

  tags = {
    Name = "Server ${count.index}"
  }
}
```


### Count

The count argument replicates the given resource or module a specific number of times with an incrementing counter. 
It works best when resources will be identical, or nearly so.

[Specification](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

```HCL
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
resource "aws_instance" "server" {
  # Create one instance for each subnet
  count = length(["id-1","id-2"])
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[count.index]

  tags = {
    Name = "Server ${count.index}"
  }
}
```


### For_each

The for_each meta-argument accepts a map or a set of strings, and creates an instance for each item in that map or set. 
Each instance has a distinct infrastructure object associated with it, and each is separately created, updated, or destroyed 
when the configuration is applied.

[Specification](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

- each.key — The map key (or set member) corresponding to this instance.
- each.value — The map value corresponding to this instance. (If a set was provided, this is the same as each.key.)

#### When to Use for_each Instead of count
If your instances are almost identical, count is appropriate. If some of their arguments need distinct values that can't 
be directly derived from an integer, it's safer to use for_each.

```HCL
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
module "bucket" {
  for_each = toset(["assets", "media"])
  source   = "./publish_bucket"
  name     = "${each.key}_bucket"
}
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}
```


### Splat expression

A splat expression provides a more concise way to express a common operation that could otherwise be performed with a for expression.
- The splat expression patterns apply only to lists, sets, and tuples.

[Specification](https://developer.hashicorp.com/terraform/language/expressions/splat)

```HCL
[for o in var.list : o.id]
var.list[*].id
```

### Example
- dev.tfvars
- variables.tf
- locals.tf
- main.tf
- cf.tf
- outputs.tf
