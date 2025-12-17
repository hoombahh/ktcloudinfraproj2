# openstack/provider.tf

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.50.0"
    }
  }
}

provider "openstack" {
  # Jenkins 에이전트나 로컬 PC의 ~/.config/openstack/clouds.yaml 정보를 참조합니다.
  cloud = "openstack" 
}
