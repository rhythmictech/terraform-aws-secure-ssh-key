module "lambda_package" {
  source  = "matti/resource/shell"
  version = "~>1.0.7"

  # I want to be using `npm run-script build` here,
  # but for some reason I can't work out `node-lambda` fails in that context
  command     = "node-lambda package -e production -x 'event.json build.env bin .github' -I lambci/lambda:build-nodejs12.x"
  working_dir = "${path.module}/lambda"

  trigger = join("", values({
    package_lock_json = filemd5("${path.module}/lambda/package-lock.json")
    package_json      = filemd5("${path.module}/lambda/package.json")
    app               = filemd5("${path.module}/lambda/index.js")
  }))
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

locals {
  zipfile = "${path.module}/lambda/build/lambda-ssh-key-secret-production.zip"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "secretsmanager_read_write" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_lambda_function" "this" {
  depends_on = [
    module.lambda_package
  ]

  filename         = local.zipfile
  function_name    = var.name
  handler          = "index.handler"
  role             = aws_iam_role.this.arn
  runtime          = "nodejs12.x"
  source_code_hash = try(filebase64sha256(local.zipfile), null)

  lifecycle {
    ignore_changes = [
      filename,
      last_modified
    ]
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    }
  )
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

  command = "aws lambda invoke --function-name ${aws_lambda_function.this.function_name} --payload '${jsonencode(local.key_params)}' /tmp/lambda_invocation_output"
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
}
