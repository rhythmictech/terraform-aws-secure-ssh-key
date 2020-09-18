module "secure_ssh_key" {
  source  = "rhythmictech/secure-ssh_key/aws"
  version = "~> 1.0.0-rc1"

  name = "my-secure-key"
}

output "secret_name" {
  value = module.secure_ssh_key.privkey_secret_name
}
