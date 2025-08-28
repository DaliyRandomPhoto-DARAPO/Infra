variable "aws_region" {
  type    = string
  default = "ap-northeast-2" # 서울
}

variable "env" {
  type    = string
  default = "dev"
}

variable "instance_type" {
  type    = string
  default = "t4g.medium"
}

variable "mongodb_connection_string" {
  description = "MongoDB Atlas Connection String"
  type        = string
  sensitive   = true
}

variable "notification_email" {
  description = "Email address for notifications (SNS, Budgets)"
  type        = string
  default     = "hhee445567@gmail.com"
}

variable "domain_name" {
  description = "Domain name for Route53 (leave empty if not using custom domain)"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID (optional, will be looked up by domain_name if empty)"
  type        = string
  default     = ""
}
