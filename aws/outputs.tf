output "rds_endpoint" {
  description = "RDS 접속 주소"
  value       = aws_db_instance.default.address
}

output "cluster_endpoint" {
  description = "EKS 클러스터 주소"
  value       = module.eks.cluster_endpoint
}
