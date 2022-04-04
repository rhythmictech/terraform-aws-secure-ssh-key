module "secure_ssh_key" {
  # source  = "rhythmictech/secure-ssh-key/aws"
  # version = "2.0.1"
  source = "../.."

  name = "my-secure-key"
}

output "secret_name" {
  value = module.secure_ssh_key.privkey_secret_name
}
