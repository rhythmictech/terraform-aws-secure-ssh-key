
variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "secret_description" {
  default     = "A password created by Terraform" #tfsec:ignore:GEN001
  description = "Set a description for the secret"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
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
