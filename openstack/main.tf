# openstack/main.tf

# 1. 전용 내부 네트워크 및 서브넷 생성
resource "openstack_networking_network_v2" "active_net" {
  name           = "active-internal-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "active_subnet" {
  name       = "active-internal-subnet"
  network_id = openstack_networking_network_v2.active_net.id
  cidr       = "192.168.10.0/24"
  ip_version = 4
}

# 2. 라우터 생성 및 외부망(sharednet1) 게이트웨이 설정
resource "openstack_networking_router_v2" "active_router" {
  name                = "active-router"
  admin_state_up      = "true"
  external_network_id = var.external_network_id
}

# 3. 라우터와 내부 서브넷 연결 (인터넷 통신 가능해짐)
resource "openstack_networking_router_interface_v2" "router_intf" {
  router_id = openstack_networking_router_v2.active_router.id
  subnet_id = openstack_networking_subnet_v2.active_subnet.id
}

# 4. 보안 그룹 및 규칙 생성 (직접 만드는 것이 관리상 유리)
resource "openstack_networking_secgroup_v2" "active_sg" {
  name        = "active-web-sg"
  description = "Security group for Active Web Servers"
}

resource "openstack_networking_secgroup_rule_v2" "rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.active_sg.id
}

# 5. 인스턴스 생성
resource "openstack_compute_instance_v2" "web_server" {
  count           = 2
  name            = "active-web-${count.index + 1}"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.active_sg.name]

  network {
    uuid = openstack_networking_network_v2.active_net.id
  }
}
