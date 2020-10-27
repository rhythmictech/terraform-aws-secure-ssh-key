# Useful outputs

output "privkey_secret_arn" {
  description = "The ARN of the SecretsManager privkey Secret"
  value       = aws_secretsmanager_secret.privkey.arn
}

output "pubkey_secret_arn" {
  description = "The ARN of the SecretsManager privkey Secret"
  value       = aws_secretsmanager_secret.pubkey.arn
}

output "privkey_secret_name" {
  description = "The name of the privkey secret"
  value       = aws_secretsmanager_secret.privkey.name
}

output "pubkey_secret_name" {
  description = "The name of the privkey secret"
  value       = aws_secretsmanager_secret.pubkey.name
}

output "ssh_pubkey" {
  description = "The SSH pubkey"
  value       = module.pubkey.stdout
}
