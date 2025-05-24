resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.app.id
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
  
resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_security_group" "jenkins_VM_sg" {
  name        = "jenkins_VM_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.app.id
  ingress = [
    for port in [22, 80, 8080, 9000, 3000, 9100, 9090, 443, 8081, 587] : {
      description = "inbound rules"

      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "jenkins-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins_VM_sg.id]
  # vpc_id                 = aws_vpc.app.id
  user_data = file("${path.module}/jenkins-script.sh")
  root_block_device {
    volume_size = 30 # Increase this value (e.g., from 8GB to 20GB)
    #volume_type = "gp3"
  }

  tags = {
    Name = "jenkins-Server"
  }
}

resource "aws_instance" "infra-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins_VM_sg.id]
  # vpc_id                 = aws_vpc.app.id
  user_data = file("${path.module}/infra-script.sh")
  root_block_device {
    volume_size = 30 # Increase this value (e.g., from 8GB to 20GB)
    #volume_type = "gp3"
  }

  tags = {
    Name = "infra-server"
  }
}

resource "aws_instance" "nexus-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins_VM_sg.id]
  # vpc_id                 = aws_vpc.app.id
  user_data = file("${path.module}/nexus-script.sh")
  root_block_device {
    volume_size = 30 # Increase this value (e.g., from 8GB to 20GB)
    #volume_type = "gp3"
  }

  tags = {
    Name = "Nexus-Server"
  }
}

resource "aws_instance" "sonarqube-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins_VM_sg.id]
  # vpc_id                 = aws_vpc.app.id
  user_data = file("${path.module}/sonarqube-script.sh")
  root_block_device {
    volume_size = 30 # Increase this value (e.g., from 8GB to 20GB)
    #volume_type = "gp3"
  }

  tags = {
    Name = "sonarqube-Server"
  }
}