terraform {
  required_version = "~> 1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
  backend "s3" {
    bucket         = "kittens-test-terraform"
    dynamodb_table = "kittens-test-terraform-lock"
    encrypt        = true
    key            = "kittens-test-terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
