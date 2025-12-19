# openstack/variables.tf

variable "external_network_id" {
  description = "인터넷 연결을 위한 sharednet1의 UUID"
  type        = string
  default     = "04a2babe-e5b2-4be7-b34a-eb5c4c750375" 
}

variable "image_name" {
  description = "인스턴스에 사용할 OS 이미지 이름"
  type        = string
  default     = "Ubuntu" 
}

variable "flavor_name" {
  description = "인스턴스 사양 (Flavor)"
  type        = string
  default     = "m1.medium" 
}

variable "key_pair" {
  description = "접속용 키페어 이름"
  type        = string
  default     = "active-keypair"
}
