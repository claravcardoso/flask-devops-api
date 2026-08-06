output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.api.id
}

output "public_ip" {
  description = "Endereço IP público da EC2"
  value       = aws_instance.api.public_ip
}

output "public_dns" {
  description = "DNS público da EC2"
  value       = aws_instance.api.public_dns
}

output "application_url" {
  description = "Endereço público da aplicação"
  value       = "http://${aws_instance.api.public_ip}"
}

output "health_url" {
  description = "Endereço do health check"
  value       = "http://${aws_instance.api.public_ip}/health"
}

output "ssh_command" {
  description = "Comando SSH para conexão"
  value       = "ssh -i ../devops-api-key.pem ec2-user@${aws_instance.api.public_ip}"
}