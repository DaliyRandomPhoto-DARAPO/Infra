# EC2 Instance 정보
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "EC2 Public IP (변경될 수 있음)"
  value       = aws_instance.app.public_ip
}

output "elastic_ip" {
  description = "Elastic IP (고정 IP 주소)"
  value       = aws_eip.app.public_ip
}

output "application_url" {
  description = "Application URL (Elastic IP 사용)"
  value       = "http://${aws_eip.app.public_ip}/"
}

# MongoDB 연결 정보
output "mongodb_connection_string" {
  description = "MongoDB Atlas Connection String"
  value       = var.mongodb_connection_string
  sensitive   = true
}

# SNS 정보
output "sns_topic_arn" {
  description = "SNS Topic ARN for alarms"
  value       = aws_sns_topic.alarms.arn
}

# 도메인 정보 (도메인이 설정된 경우에만)
output "domain_urls" {
  description = "Domain URLs"
  value = var.domain_name != "" ? {
    root = "https://${var.domain_name}/"
    api  = "https://api.${var.domain_name}/"
  } : null
}
