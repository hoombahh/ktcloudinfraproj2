# outputs.tf

# 첫 번째 VM (Master용)의 공인 IP
output "master_ip" {
  value = openstack_networking_floatingip_v2.fip[0].address
}

# 두 번째 VM (Worker용)의 공인 IP
output "worker_ip" {
  value = openstack_networking_floatingip_v2.fip[1].address
}
