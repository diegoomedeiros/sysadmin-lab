terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Provider
provider "aws" {
  profile = "default"
  region  = var.region
}

