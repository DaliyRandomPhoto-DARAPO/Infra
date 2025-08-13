variable "aws_region" {
  type    = string
  default = "ap-northeast-2" # 서울
}

variable "env" {
  type    = string
  default = "dev"
}

variable "ssh_key_name" {
  description = "EC2에 붙일 기존 Key Pair 이름"
  type        = string
  default     = "darapo-key"
}

variable "ssh_ingress_cidr" {
  description = "SSH 허용 CIDR (내 IP/32 추천)"
  type        = string
  default     = "0.0.0.0/0"  # 데모용. 운영에선 꼭 본인 IP로 제한!
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}
