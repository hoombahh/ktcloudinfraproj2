# openstack/backend.tf

terraform {
  backend "s3" {
    bucket         = "ktcloudinfraproj2-terraform-state"
    key            = "active/terraform.tfstate"
    region         = "ap-northeast-2"
    
    # --- 추가해야 할 부분 (KT Cloud 호환 설정) ---
    # KT Cloud Object Storage의 주소 (Endpoint)를 적어야 합니다.
    # 보통 https://s3.pub-ap-northeast-2.ktcloudtos.com 형태입니다.
    # 정확한 주소는 KT Cloud 콘솔의 Object Storage 상세 정보에서 확인 가능합니다.
    endpoint = "https://s3.pub-ap-northeast-2.ktcloudtos.com" 

    # AWS가 아니므로 검증 절차를 건너뛰는 옵션들입니다.
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    encrypt                     = true
  }
}
