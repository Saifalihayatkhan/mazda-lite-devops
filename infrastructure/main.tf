provider "aws" {
  region = "us-east-1"  # N. Virginia is standard for Free Tier
}

# 1. Create a Security Group (Firewall)
resource "aws_security_group" "mazda_sg" {
  name        = "mazda-lite-sg"
  description = "Allow SSH, HTTP, and K8s traffic"

  # SSH Access (For you to login)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to your IP!
  }

  # HTTP Access (For the Dealer Portal)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePort Access (Range for K3s Services)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic (Allow server to download Docker images)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Generate a Private Key locally
resource "tls_private_key" "mazda_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 3. Upload the Public Key to AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "mazda-devops-key"
  public_key = tls_private_key.mazda_key.public_key_openssh
}

# 4. Save the Private Key to your computer (so you can login)
resource "local_file" "private_key" {
  content  = tls_private_key.mazda_key.private_key_pem
  filename = "${path.module}/mazda-key.pem"
}

# 5. Create the EC2 Instance (The Server)
resource "aws_instance" "mazda_server" {
  ami           = "ami-0e2c8caa4b6378d8c" # Ubuntu 24.04 LTS (us-east-1)
  instance_type = "t2.micro"              # Free Tier Eligible
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.mazda_sg.id]

  tags = {
    Name = "Mazda-Lite-Cluster"
  }
}

# 6. Output the Public IP address
output "server_ip" {
  value = aws_instance.mazda_server.public_ip
}