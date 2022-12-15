# [Voltar](../README.md)

# Terraform AWS LocalStack

This module showing to basic example to used case in `LocalStack` with integration `Terraform`, for consulting to access this link [Integration Terraform](https://docs.localstack.cloud/integrations/terraform/).

After that, execute the following commands as need.

## LocalStack

For to up infrastructure in AWS locally, execute:

```sh
$ docker-compose up -d --build
```

For to down infrastructure, execute:

```sh
$ docker-compose down
```

## AWS

Whereas you already `aws-cli` installed and configured correctly, execute:

```sh
$ aws configure --profile localstack
```

Add credentials as need it:

```
para access_key : mock_access_key
para secret_key : mock_secret_key
para region : us-east-1
para output : json
```

To query a resource, following as example:

```sh
$ aws --endpoint-url=http://localhost:4566 s3 ls --profile localstack
```

## Terraform

Whereas you already `terraform` cli installed and configured correctly, execute:

```sh
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
$ terraform destroy
```

## Example

As copy and to view an picture in bucket S3, following commands below:

```sh
$ aws --endpoint-url=http://localhost:4566 s3 ls --profile localstack
$ aws --endpoint-url=http://localhost:4566 s3 cp imgs/pug.png s3://my-bucket-localstack/ --profile localstack
$ aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket-localstack --recursive --human-readable --summarize --profile localstack
$ aws --endpoint-url=http://localhost:4566 s3 rm s3://my-bucket-localstack/pug.png --profile localstack
```

URL to show picture:
`http://localhost:4566/my-bucket-localstack/pug.png`