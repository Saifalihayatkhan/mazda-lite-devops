provider "aws" {
  region = "us-east-1"
}

# 1. Security Group (Updated with NodePort range)
resource "aws_security_group" "mazda_sg" {
  name        = "mazda-lite-sg-v2"
  description = "Allow SSH, HTTP, and K8s NodePorts"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # K8s NodePort Access (For ArgoCD UI & App)
  # This fixes the "Site can't be reached" error automatically
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Generate Private Key
resource "tls_private_key" "mazda_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 3. Upload Public Key to AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "mazda-devops-key-v2"
  public_key = tls_private_key.mazda_key.public_key_openssh
}

# 4. Save Private Key locally
resource "local_file" "private_key" {
  content  = tls_private_key.mazda_key.private_key_pem
  filename = "${path.module}/mazda-key.pem"
}

# 5. EC2 Instance (Upgraded to t2.medium)
resource "aws_instance" "mazda_server" {
  ami           = "ami-0e2c8caa4b6378d8c" # Ubuntu 24.04 LTS
  instance_type = "t2.medium"             # UPGRADED: 2 vCPU, 4GB RAM
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.mazda_sg.id]

  tags = {
    Name = "Mazda-Lite-Cluster-Medium"
  }
}

output "server_ip" {
  value = aws_instance.mazda_server.public_ip
}