variable "aws_region" {
  description = "Região AWS utilizada pelo projeto"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "flask-devops-api"
}

variable "environment" {
  description = "Nome do ambiente"
  type        = string
  default     = "academy"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nome do key pair previamente criado na AWS"
  type        = string
  default     = "devops-api-key"
}

variable "ssh_cidr" {
  description = "Endereço IP autorizado a acessar a porta SSH"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr))
    error_message = "ssh_cidr deve ser um bloco CIDR válido, como 200.100.50.25/32."
  }
}