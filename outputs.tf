# Useful outputs

output "secret_arn" {
  description = "The ARN of the SecretsManager Secret"
  value       = aws_secretsmanager_secret.privkey.arn
}

output "ssh_pubkey" {
  description = "The SSH pubkey"
  value       = data.aws_secretsmanager_secret_version.pubkey.secret_string
}


# These outputs are for debugging and trying to control the dependency chart. Can be much cleaner in TF 0.13.0

output "result" {
  description = "String result of Lambda execution"
  value       = module.lambda_invocation_result.stdout
}

output "invocation_stdout" {
  description = "stdout of invocation command"
  value       = module.lambda_invocation.stdout
}

output "invocation_stderr" {
  description = "stderr of invocation command"
  value       = module.lambda_invocation.stderr
}

output "invocation_result_stderr" {
  description = "stderr of invocation_result"
  value       = module.lambda_invocation_result.stderr
}
