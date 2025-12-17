# 1. 대시보드에서 직접 만든 네트워크와 서브넷 정보 가져오기
data "openstack_networking_network_v2" "inner_net" {
  name = "kt-active-net"
}

data "openstack_networking_subnet_v2" "inner_subnet" {
  name = "kt-active-subnet"
}

# 2. 대시보드에서 직접 만든 보안 그룹 'active' 정보 가져오기
data "openstack_networking_secgroup_v2" "active_sg" {
  name = "active"
}

# 3. 웹 서버 인스턴스 생성 (2대)
resource "openstack_compute_instance_v2" "active_web" {
  count           = 2
  name            = "active-web-${count.index + 1}"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair
  
  # 수동으로 만든 'active' 보안 그룹 적용
  security_groups = [data.openstack_networking_secgroup_v2.active_sg.name]

  network {
    uuid = data.openstack_networking_network_v2.inner_net.id
  }

  # 서브넷이 활성화된 상태에서 생성되도록 의존성 설정
  depends_on = [data.openstack_networking_subnet_v2.inner_subnet]
}
