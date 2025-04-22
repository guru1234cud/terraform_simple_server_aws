provider "aws" {
  region = "ap-south-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "GW"
  }
}
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "RT"
  }
}
resource "aws_subnet" "SN" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "subnet-ia"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.SN.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_security_group" "SG_1" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowWebTraffic"
  }

}
resource "aws_network_interface" "web_sever_nic" {
  subnet_id       = aws_subnet.SN.id
  private_ips      = ["10.0.1.50"]
  security_groups = [aws_security_group.SG_1.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web_sever_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}
resource "aws_instance" "web-server" {
  ami               = "ami-0e35ddab05955cf57"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "final"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_sever_nic.id
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo webserver > /var/www/html/index.html'
              EOF
  tags = {
    Name = "web server"
  }
}
