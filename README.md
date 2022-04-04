# terraform-aws-secure-ssh-key
Creates an ssh key with a Lambda data source and saves it in a secrets manager secret, allowing the creation of ssh keys without saving them in state

[![tflint](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/tflint/badge.svg)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Atflint+event%3Apush+branch%3Amain)
[![tfsec](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/tfsec/badge.svg)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amain)
[![yamllint](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/yamllint/badge.svg)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amain)
[![misspell](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/misspell/badge.svg)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amain)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

## Example
Here's what using the module will look like
```hcl
module "secure_ssh_key" {
  source  = "rhythmictech/secure-ssh-key/aws"
  version = "~> 2.0.1"

  name   = "my-secure-key"
}

output "secret_name" {
  value = module.secure_ssh_key.privkey_secret_name
}

```

## About
Creates an ssh key with a Lambda data source and saves it in a secrets manager secret, allowing the creation of ssh keys without saving them in state

## Dependencies
* Python >= 3.8

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.28 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.45.0, < 4.0.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 1.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~>2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.1 |
| <a name="provider_external"></a> [external](#provider\_external) | 1.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 2.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_version"></a> [lambda\_version](#module\_lambda\_version) | rhythmictech/find-release-by-semver/github | >= 1.0.0-rc1, < 2.0.0 |
| <a name="module_pubkey"></a> [pubkey](#module\_pubkey) | matti/resource/shell | ~> 1.0.7 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secret_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_secretsmanager_secret.privkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.pubkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [null_resource.lambda_invoke](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.lambda_zip](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secret_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [external_external.sha](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_keepers"></a> [keepers](#input\_keepers) | Arbitrary map of values that when changed will force a new password | `map(string)` | `{}` | no |
| <a name="input_key_bits"></a> [key\_bits](#input\_key\_bits) | Number of bits to be used in RSA key generation | `number` | `2048` | no |
| <a name="input_lambda_version_constraint"></a> [lambda\_version\_constraint](#input\_lambda\_version\_constraint) | NPM-style version constraint for the version of the lambda code you want to use | `string` | `"^1.0.2-rc2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Moniker to apply to all resources in the module | `string` | n/a | yes |
| <a name="input_secret_description"></a> [secret\_description](#input\_secret\_description) | Set a description for the secret | `string` | `"An SSH key secret by Terraform"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-Defined tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_privkey_secret_arn"></a> [privkey\_secret\_arn](#output\_privkey\_secret\_arn) | The ARN of the SecretsManager privkey Secret |
| <a name="output_privkey_secret_name"></a> [privkey\_secret\_name](#output\_privkey\_secret\_name) | The name of the privkey secret |
| <a name="output_pubkey_secret_arn"></a> [pubkey\_secret\_arn](#output\_pubkey\_secret\_arn) | The ARN of the SecretsManager privkey Secret |
| <a name="output_pubkey_secret_name"></a> [pubkey\_secret\_name](#output\_pubkey\_secret\_name) | The name of the privkey secret |
| <a name="output_ssh_pubkey"></a> [ssh\_pubkey](#output\_ssh\_pubkey) | The SSH pubkey |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants Underneath this Module
- [pre-commit.com](pre-commit.com)
- [terraform.io](terraform.io)
- [github.com/tfutils/tfenv](github.com/tfutils/tfenv)
- [github.com/segmentio/terraform-docs](github.com/segmentio/terraform-docs)
