# 형님의 RDS 리소스 이름이 "default"라고 가정했습니다.
# 만약 main.tf에서 resource "aws_db_instance" "mydb" 이렇게 되어 있으면
# 아래 "aws_db_instance.default.address"를 "aws_db_instance.mydb.address"로 바꿔야 합니다!

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.default.address 
}
