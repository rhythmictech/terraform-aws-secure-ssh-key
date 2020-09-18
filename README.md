# terraform-aws-secure-ssh-key
Creates an ssh key with a Lambda data source and saves it in a secrets manager secret, allowing the creation of ssh keys without saving them in state

[![tflint](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/tflint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Atflint+event%3Apush+branch%3Amain)
[![tfsec](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/tfsec/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amain)
[![yamllint](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/yamllint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amain)
[![misspell](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/misspell/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amain)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/workflows/pre-commit-check/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-secure-ssh-key/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amain)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

## Example
Here's what using the module will look like
```hcl
module "secure_ssh_key" {
  source  = "rhythmictech/secure-ssh_key/aws"
  version = "~> 1.0.0-rc1"

  name   = "my-secure-key"
}

output "secret_name" {
  value = module.secure_ssh_key.privkey_secret_name
}

```

## About
Creates an ssh key with a Lambda data source and saves it in a secrets manager secret, allowing the creation of ssh keys without saving them in state

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.28 |
| aws | >= 2.45.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.45.0, < 4.0.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Moniker to apply to all resources in the module | `string` | n/a | yes |
| keepers | Arbitrary map of values that when changed will force a new password | `map(string)` | `{}` | no |
| key\_bits | Number of bits to be used in RSA key generation | `number` | `2048` | no |
| lambda\_version\_constraint | NPM-style version constraint for the version of the lambda code you want to use | `string` | `"^1.0.0-rc1"` | no |
| secret\_description | Set a description for the secret | `string` | `"An SSH key secret by Terraform"` | no |
| tags | User-Defined tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| privkey\_secret\_arn | The ARN of the SecretsManager privkey Secret |
| privkey\_secret\_name | The name of the privkey secret |
| pubkey\_secret\_arn | The ARN of the SecretsManager privkey Secret |
| pubkey\_secret\_name | The name of the privkey secret |
| ssh\_pubkey | The SSH pubkey |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants Underneath this Module
- [pre-commit.com](pre-commit.com)
- [terraform.io](terraform.io)
- [github.com/tfutils/tfenv](github.com/tfutils/tfenv)
- [github.com/segmentio/terraform-docs](github.com/segmentio/terraform-docs)
