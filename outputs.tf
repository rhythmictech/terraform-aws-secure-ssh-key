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

output "ssh_pubkey" {
  description = "The SSH pubkey"
  value       = data.aws_secretsmanager_secret_version.pubkey.secret_string
}
