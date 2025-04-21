provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.4.0"
  backend "remote" {
    organization = "your_terraform_org"

    workspaces {
      name = "aws-security-monitoring"
    }
  }
}

module "prowler" {
  source      = "./modules/prowler"
  region      = var.region
  bucket_name = var.prowler_bucket
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "prowler_bucket" {
  description = "S3 bucket for Prowler reports"
  type        = string
}
