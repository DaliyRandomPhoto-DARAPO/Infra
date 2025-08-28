# 최신 Amazon Linux 2023 AMI (arm64)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }
}

# SSH 키 페어
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(pathexpand("~/.ssh/darapo-ec2-key.pub"))
}

resource "aws_security_group" "app" {
  name        = "darapo-${var.env}-app-sg"
  description = "Security group for Darapo application"
  vpc_id      = module.vpc.vpc_id

  # SSH (운영 시 본인 IP로 제한 권장 - 보안 위험!)
  ingress {
    description = "SSH - WARNING: Open to all IPs for development"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (Let's Encrypt 인증용)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (프로덕션 트래픽)
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

# EC2 인스턴스 (퍼블릭 서브넷)
resource "aws_instance" "app" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 40
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    env = var.env
  }))

  tags = {
    Name    = "darapo-${var.env}-app"
    Project = "darapo"
  }
}