# openstack/provider.tf

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.50.0" # 최신 안정 버전 사용
    }
  }
}

provider "openstack" {
  # 담당자에게 받은 clouds.yaml을 쓰거나 환경변수를 쓸 예정이므로 
  # 여기엔 구체적인 ID/PW를 적지 않고 비워두는 것이 보안상 좋습니다.
  cloud = "openstack" 
}
