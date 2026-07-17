terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "03"
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "03"
    }
  }
}