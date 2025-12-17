# 1. 네트워크 및 서브넷 생성 (담당자 가이드 반영)
resource "openstack_networking_network_v2" "inner_net" {
  name           = "kt-active-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "inner_subnet" {
  name            = "kt-active-subnet"
  network_id      = openstack_networking_network_v2.inner_net.id
  cidr            = "192.168.10.0/24" # 당신이 정한 내부 대역
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# 2. 라우터 생성 및 외부망(sharednet1) 연결
resource "openstack_networking_router_v2" "active_router" {
  name                = "kt-active-router"
  admin_state_up      = "true"
  external_network_id = var.external_network_id # variables.tf에 sharednet1 ID 넣기
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.active_router.id
  subnet_id = openstack_networking_subnet_v2.inner_subnet.id
}

# 3. 보안 그룹 정의
resource "openstack_networking_secgroup_v2" "active_sg" {
  name        = "kt-active-sg"
  description = "Security group for Active Web Servers"
}

# HTTP(80) 허용 규칙
resource "openstack_networking_secgroup_rule_v2" "rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.active_sg.id
}

# SSH(22) 허용 규칙 (접속을 위해 추가 권장)
resource "openstack_networking_secgroup_rule_v2" "rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.active_sg.id
}

# 4. 인스턴스 생성
resource "openstack_compute_instance_v2" "active_web" {
  count           = 2
  name            = "active-web-${count.index + 1}"
  image_name      = var.image_name 
  flavor_name     = var.flavor_name # variables.tf에서 지정하거나 "m1.medium" 직접 기입
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.active_sg.name]

  network {
    uuid = openstack_networking_network_v2.inner_net.id
  }

  # 인스턴스 생성 시 서브넷이 먼저 준비되어야 하므로 종속성 명시
  depends_on = [openstack_networking_subnet_v2.inner_subnet]
}
