
#!/bin/bash

sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#Install Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install terraform -y

#Install HELM
sudo apt update && sudo apt upgrade -y
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

wget https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz
tar -zxvf helm-v3.14.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# install eksctl
curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"

tar -xzf eksctl_$(uname -s)_amd64.tar.gz

sudo mv eksctl /usr/local/bin

# changing hostname

hostnamectl set-hostname infra-server
echo "127.0.0.1 infra-server" >> /etc/hosts


