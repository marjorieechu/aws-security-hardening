variable "region" {
  description = "AWS Region"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH"
  type        = string
}

variable "zeek_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "VPC ID for EC2"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}
