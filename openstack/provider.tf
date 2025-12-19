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
  cloud = "openstack" 
}
