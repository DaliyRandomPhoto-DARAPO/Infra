module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "darapo-${var.env}-vpc"
  cidr = "10.0.0.0/16"

  # 고가용성을 위한 다중 AZ 설정 (개발 환경에서는 1개 AZ 사용)
  azs             = ["${var.aws_region}a"]
  public_subnets  = ["10.0.0.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true

  # NAT 게이트웨이 비활성화 (퍼블릭 서브넷만 사용)
  enable_nat_gateway = false

  public_subnet_tags = {
    Tier = "public"
  }

  tags = {
    Name = "darapo-${var.env}-vpc"
  }
}
