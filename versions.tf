terraform {

  backend "s3" {
    bucket = "vadossam-tfstate"
    key    = "aws.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }

    null = {
      version = "3.1.1"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = var.region
}
