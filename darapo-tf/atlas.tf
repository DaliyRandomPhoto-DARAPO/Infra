# MongoDB Atlas 연결 정보 관리
# 보안: 민감한 정보는 외부에서 주입받거나 SSM Parameter Store를 사용하세요

# SSM Parameter Store에 MongoDB URI 저장
# 나중에 IAM 권한이 부여되면 아래 리소스를 활성화하세요
# resource "aws_ssm_parameter" "mongo_uri" {
#   name  = "/darapo/mongo_uri"
#   type  = "SecureString"
#   value = var.mongodb_connection_string
# }
