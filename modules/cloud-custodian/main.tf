resource "aws_security_group" "custodian_sg" {
  name        = "cloud-custodian-sg"
  description = "Allow SSH access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "custodian" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.custodian_instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.custodian_sg.id]

  user_data = file("${path.module}/install_custodian.sh")

  tags = {
    Name = "CloudCustodian"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

output "custodian_instance_id" {
  value = aws_instance.custodian.id
}

output "custodian_public_ip" {
  value = aws_instance.custodian.public_ip
}
