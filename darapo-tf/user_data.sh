#!/bin/bash
set -e

# 환경 변수 설정 (Terraform 변수로부터)
ENV="${env}"

# 시스템 업데이트
yum update -y

# 기본 패키지 설치 (필요에 따라 수정)
yum install -y git wget curl

# CloudWatch 에이전트 설치 (모니터링용)
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U amazon-cloudwatch-agent.rpm

# CloudWatch 에이전트 설정 (메모리, 디스크 모니터링)
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/messages",
                        "log_group_name": "darapo-${env}-app-logs",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    },
    "metrics": {
        "metrics_collected": {
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ]
            },
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "resources": [
                    "/"
                ]
            }
        }
    }
}
EOF

# CloudWatch 에이전트 시작
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

echo "Basic setup completed. Application deployment required."
