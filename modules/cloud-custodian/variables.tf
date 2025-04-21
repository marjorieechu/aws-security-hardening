variable "region" {
  description = "AWS Region"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH"
  type        = string
}

variable "custodian_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID for EC2"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}
