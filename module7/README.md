# [Voltar](../README.md)

### Lifecycle

[Specification](https://developer.hashicorp.com/terraform/tutorials/state/resource-lifecycle)

[Specification](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

```HCL
resource "aws_cloudfront_distribution" "distribution" {
  ...
    lifecycle {
      ignore_changes = [enabled]
      prevent_destroy = true
      create_before_destroy = true
      replace_triggered_by = [tags]
    }
  ...
```

### Condition checks

[Specification](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#custom-condition-checks)

[Specification](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

- Use Preconditions for Assumptions (before create, before update, before delete)
- Use Postconditions for Guarantees (after create, after update, after delete)

```HCL
resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-abc123"

  lifecycle {
    # The AMI ID must refer to an AMI that contains an operating system
    # for the `x86_64` architecture.
    precondition {
      condition     = data.aws_ami.example.architecture == "x86_64"
      error_message = "The selected AMI must be for the x86_64 architecture."
    }
  }
}
data "aws_ebs_volume" "example" {
  filter {
    name = "volume-id"
    values = [aws_instance.example.root_block_device.volume_id]
  }
  lifecycle {
    # The EC2 instance will have an encrypted root volume.
    postcondition {
      condition     = self.encrypted
      error_message = "The server's root volume is not encrypted."
    }
  }
}
variable "location" {
    ...
    validation {
      condition     = can(regex("^australia*", var.location))
      error_message = "Err: provided location is not within australia."
    }
    ...
}
```

### GitOps

...