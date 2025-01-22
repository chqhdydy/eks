# eks

실행 순서

1. main.tf를 실행하여 기본 인프라 생성
    terraform init
    terraform plan(옵션)
    terraform apply (적용)
    terraform destroy (삭제)

2. cluster-config.yaml를 실행 하여 eks 생성
    eksctl create cluster -f cluster-config.yaml (생성)
    eksctl delete cluster -f cluster-config.yaml(삭제)
    삭제는 직접 cloudformation에서 지우는걸 권장


3. kubectl apply -f .\aws-auth.yaml 해줄것
    인증문제

4. git add, commit, push를 실행 그 후 자동생성 \


깔아야 할것

kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

추가 eks 노드그룹 iam역할에 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVolume",
                "ec2:DeleteVolume",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications",
                "ec2:ModifyVolume"
            ],
            "Resource": "*"
        }
    ]
}
이거 추가해야함

aaaa