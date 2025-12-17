# openstack/backend.tf

terraform {
  backend "s3" {
    bucket         = "ktcloudinfraproj2-terraform-state" # 김기윤 팀원에게 확인받은 버킷명
    key            = "active/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    # dynamodb_table = "terraform-lock" # 필요 시 설정
  }
}
