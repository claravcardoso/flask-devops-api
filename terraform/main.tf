data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"

    values = [
      data.aws_vpc.default.id
    ]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = [
    "amazon"
  ]

  filter {
    name = "name"

    values = [
      "al2023-ami-2023*-x86_64"
    ]
  }

  filter {
    name = "architecture"

    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }

  filter {
    name = "root-device-type"

    values = [
      "ebs"
    ]
  }
}

resource "aws_security_group" "api" {
  name_prefix = "${var.project_name}-"
  description = "Acesso HTTP e SSH para a API Flask"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH administracao"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [
      var.ssh_cidr
    ]
  }

  ingress {
    description = "API HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description = "Saida para internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-security-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.api.id]

  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash

    set -e

    dnf update -y
    dnf install -y docker git curl

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ec2-user

    mkdir -p /opt/flask-devops-api
    chown -R ec2-user:ec2-user /opt/flask-devops-api
  EOF

  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}"
  }
}