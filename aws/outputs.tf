output "rds_endpoint" {
  description = "RDS 접속 주소"
  value       = aws_db_instance.default.address
}
