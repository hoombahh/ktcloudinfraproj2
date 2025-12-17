# openstack/variables.tf

variable "external_network_id" {
  description = "인터넷 연결을 위한 sharednet1의 UUID"
  type        = string
  default     = "여기에_sharednet1_ID_입력" 
}

variable "image_name" {
  description = "인스턴스에 사용할 OS 이미지 이름"
  type        = string
  default     = "Ubuntu-22.04" # 확인하신 이미지 중 하나 선택
}

variable "flavor_name" {
  description = "담당자가 추천하거나 이미 존재하는 플레이버 이름"
  type        = string
  default     = "m1.medium"
}

variable "key_pair" {
  description = "접속용 키페어 이름"
  type        = string
  default     = "my-keypair"
}
