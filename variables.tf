variable "lambda_version_constraint" {
  default     = "^1.0.2-rc2"
  description = "NPM-style version constraint for the version of the lambda code you want to use"
  type        = string
}

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "secret_description" {
  default     = "An SSH key secret by Terraform" #tfsec:ignore:GEN001
  description = "Set a description for the secret"
  type        = string
}

variable "keepers" {
  default     = {}
  description = "Arbitrary map of values that when changed will force a new password"
  type        = map(string)
}

variable "key_bits" {
  default     = 2048
  description = "Number of bits to be used in RSA key generation"
  type        = number
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}
