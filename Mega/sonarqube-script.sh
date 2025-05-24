#!/bin/bash
sudo apt update -y
# install docker
sudo apt install docker.io -y 
sudo usermod -aG docker ubuntu
newgrp docker
sudo systemctl enable docker
sudo systemctl start docker

# creating sonarqube docker container
docker run -d --name sonarqube-container -p 9000:9000 sonarqube:lts-community
# changing hostname

hostnamectl set-hostname sonarqube-server
echo "127.0.0.1 sonarqube-server" >> /etc/hosts