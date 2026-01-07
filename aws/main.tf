terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# 1. 네트워크 (VPC) - DB가 살 집
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "curry-vpc-db-only"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # 👇 [핵심] 이게 없어서 아까 에러난 겁니다. DB 전용 방 추가!
  database_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# 2. 보안 그룹 (누구나 접속 가능하게 - 테스트용)
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group-test"
  description = "Allow DB traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# 3. 데이터베이스 (RDS MariaDB)
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mariadb"
  engine               = "mariadb"
  engine_version       = "10.11"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = "test1234"
  parameter_group_name = "default.mariadb10.11"
  skip_final_snapshot  = true
  publicly_accessible  = true # 외부에서 접속 테스트 하려면 true
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
}
