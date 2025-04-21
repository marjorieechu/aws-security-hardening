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

module "opa" {
  source             = "./modules/opa"
  region             = var.region
  opa_instance_type  = var.opa_instance_type
  key_name           = var.key_name
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "opa_instance_type" {
  description = "EC2 instance type for OPA"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}
