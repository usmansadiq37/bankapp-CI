#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe
sudo apt-get update 
# install docker
sudo apt-get install docker.io -y 
sudo usermod -aG docker ubuntu
newgrp docker
sudo systemctl enable docker
sudo systemctl start docker

# creating nexus docker container

docker run -d -p 8081:8081 --name nexus sonatype/nexus3

# Set hostname
sudo hostnamectl set-hostname nexus-server
echo "127.0.0.1 nexus-server" | sudo tee -a /etc/hosts