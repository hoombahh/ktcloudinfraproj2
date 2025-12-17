# 1. 수동으로 만든 네트워크 정보 (이름으로 ID 추출)
data "openstack_networking_network_v2" "inner_net" {
  name = "kt-active-net"
}

# 2. 수동으로 만든 서브넷 정보
data "openstack_networking_subnet_v2" "inner_subnet" {
  name = "kt-active-subnet"
}

# 3. 수동으로 만든 보안 그룹 정보
data "openstack_networking_secgroup_v2" "active_sg" {
  name = "active"
}

# 4. 이미지 정보 가져오기 (이름으로 ID 추출)
data "openstack_images_image_v2" "ubuntu" {
  name        = var.image_name
  most_recent = true
}

# 5. 플레이버 정보 가져오기 (이름으로 ID 추출)
data "openstack_compute_flavor_v2" "m1_medium" {
  name = var.flavor_name
}

# 6. 웹 서버 인스턴스 생성 (2대)
resource "openstack_compute_instance_v2" "active_web" {
  count           = 2
  name            = "active-web-${count.index + 1}"
  
  # 이름 대신 ID를 사용하면 훨씬 정확합니다.
  image_id        = data.openstack_images_image_v2.ubuntu.id
  flavor_id       = data.openstack_compute_flavor_v2.m1_medium.id
  key_pair        = var.key_pair
  
  # 보안 그룹 적용
  security_groups = [data.openstack_networking_secgroup_v2.active_sg.name]

  network {
    uuid = data.openstack_networking_network_v2.inner_net.id
  }

  # 인스턴스 생성 전 네트워크 준비 상태 보장
  depends_on = [
    data.openstack_networking_network_v2.inner_net,
    data.openstack_networking_subnet_v2.inner_subnet
  ]
}
