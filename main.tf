locals {
  lambda_repo_full_name = "${local.lambda_repo_owner}/${local.lambda_repo_name}"
  lambda_repo_owner     = "rhythmictech"
  lambda_repo_name      = "lambda-aws-secure-ssh-key"
}

module "lambda_version" {
  source  = "rhythmictech/find-release-by-semver/github"
  version = ">= 1.0.0-rc1, < 2.0.0"

  repo_name          = local.lambda_repo_name
  repo_owner         = local.lambda_repo_owner
  version_constraint = var.lambda_version_constraint
}

locals {
  lambda_version     = module.lambda_version.target_version
  lambda_version_tag = module.lambda_version.version_info.release_tag
}

resource "null_resource" "lambda_zip" {
  triggers = {
    on_version_change = local.lambda_version
  }

  provisioner "local-exec" {
    command = "curl -Lso ${path.module}/lambda.zip https://github.com/${local.lambda_repo_full_name}/releases/download/${local.lambda_version_tag}/lambda.zip"
  }
}

locals {
  zipfile = "${path.module}/lambda.zip"
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix = "${var.name}-"
  description = "Role for ${var.name} to create secret"

  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "secret_write" {
  statement {
    actions = [
      "secretsmanager:UpdateSecret",
      "secretsmanager:PutSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.privkey.arn,
      aws_secretsmanager_secret.pubkey.arn
    ]
  }
}

resource "aws_iam_role_policy" "secret_write" {
  name_prefix = "${var.name}-secret-write-"
  policy      = data.aws_iam_policy_document.secret_write.json
  role        = aws_iam_role.this.name
}

resource "aws_lambda_function" "this" {
  description   = "Uses ${local.lambda_repo_name} version ${local.lambda_version} to generate an ssh key and save it to a SecretsManager Secret"
  filename      = local.zipfile
  function_name = var.name
  handler       = "index.handler"
  role          = aws_iam_role.this.arn
  runtime       = "nodejs12.x"

  environment {
    variables = {
      KEY_BITS = var.key_bits
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    }
  )

  depends_on = [
    null_resource.lambda_zip
  ]
}

resource "aws_secretsmanager_secret" "privkey" {
  name_prefix = "${var.name}-privkey-"
  description = var.secret_description
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-privkey"
    }
  )
}

resource "aws_secretsmanager_secret" "pubkey" {
  name_prefix = "${var.name}-pubkey-"
  description = var.secret_description
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-pubkey"
    }
  )
}

locals {
  key_params = {
    pubkey_secret_name  = aws_secretsmanager_secret.pubkey.name
    privkey_secret_name = aws_secretsmanager_secret.privkey.name
    secret_description  = var.secret_description
  }
}

module "lambda_invocation" {
  source  = "matti/resource/shell"
  version = "~>1.0.7"

  command = "aws lambda invoke --function-name ${aws_lambda_function.this.function_name} --payload '${jsonencode(local.key_params)}' ${path.module}/tmp/lambda_invocation_output"
  trigger = join(",", values(var.keepers))

  depends = [
    aws_lambda_function.this.arn,
    aws_secretsmanager_secret.pubkey,
    aws_secretsmanager_secret.privkey
  ]
}

module "lambda_invocation_result" {
  source  = "matti/resource/shell"
  version = "~>1.0.7"

  command     = "cat /tmp/lambda_invocation_output"
  depends     = [module.lambda_invocation]
  trigger     = module.lambda_invocation.id
  working_dir = path.module
}

data "aws_secretsmanager_secret_version" "pubkey" {
  secret_id = aws_secretsmanager_secret.pubkey.id

  depends_on = [module.lambda_invocation.stdout]
}
