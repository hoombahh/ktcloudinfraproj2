// ktcloudinfraproj2/Jenkinsfile
pipeline {
    agent { label 'devops-agent-hybrid' }
    environment {
        AWS_REGION = 'ap-northeast-2' 
        TERRAFORM_DIR_OS = 'openstack'
        TERRAFORM_DIR_AWS = 'aws'
        DR_TRIGGER = env.DR_TRIGGER ?: 'false' // Job 매개변수로 주입 (기본값: false)
    }

    stages {
        stage('IaC Validation & Plan') {
            parallel {
                stage('OpenStack Check') {
                    // OpenStack Provider 인증 설정 로직이 들어갈 영역
                    steps {
                        dir("${TERRAFORM_DIR_OS}") {
                            sh "terraform init -backend=true"
                            sh "terraform validate"
                            // sh "terraform plan ..."
                        }
                    }
                }
                stage('AWS Check') {
                    // AWS Credential 설정 로직이 들어갈 영역
                    steps {
                        dir("${TERRAFORM_DIR_AWS}") {
                            sh "terraform init -backend=true"
                            sh "terraform workspace select pilot-light || terraform workspace new pilot-light"
                            sh "terraform validate"
                            // sh "terraform plan -var='is_dr_mode=false' ..."
                        }
                    }
                }
            }
        }
        
        stage('Web Deployment Pipeline Placeholder') {
            // 웹 서비스 빌드 및 배포 Job이 들어갈 영역
            steps { echo "Web Service CI/CD: Ready for Integration" }
        }

        stage('DR Master Failover Trigger') {
            // DR_TRIGGER 매개변수가 true일 때만 실행
            when { expression { env.DR_TRIGGER == 'true' } }
            steps {
                timeout(time: 30, unit: 'MINUTES') { 
                    input message: 'DR 전환을 최종 승인합니다.', ok: 'Failover 실행'
                    // DR 마스터 스크립트 호출
                    sh "python3 cicd/dr_master_script.py"
                }
            }
        }
    }
}
