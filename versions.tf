terraform {
  required_version = ">= 0.12.28"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.45.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 1.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "~>2.1.2"
    }
  }
}
