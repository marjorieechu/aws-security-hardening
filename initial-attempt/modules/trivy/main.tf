resource "aws_security_group" "trivy_sg" {
  name        = "trivy-sg"
  description = "Allow SSH and Trivy scanning access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "trivy" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.trivy_instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.trivy_sg.id]

  user_data = file("${path.module}/install_trivy.sh")

  tags = {
    Name = "TrivyScanner"
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

output "trivy_instance_id" {
  value = aws_instance.trivy.id
}

output "trivy_public_ip" {
  value = aws_instance.trivy.public_ip
}
