terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}


resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main_rt.id
}


resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD+L0zfNBVnZan8JbJK3hFefXM5okzlhjU1uDcH6EH87jfkELtyM4FQIYWH6Pf0yIKYsTZ7rHLy9K5drxHyRq85bVKeV6iGxW648vp0ER7bX38/Cof5FQ6Ox33MX8Gw0EF8AQGxQIosTQ6JvdPRq5yUnU6KhPxGx7CrQvDpv8GHVlhOlp+CCFdiOXrI3HIJGwGeBq2QcF8zkjQg4mjKhrgiUmSV1TVupVd9ZUQvIuvgoorzZZO4l4RtGwCv1kQp0V2APLt/42VfQbwVSDe6cG2fMLN1HCxypcF03HmhemfcaOofvBQIVKDOZchXQQ4MZNCG43c4H6jEmdQANkFhxA3 mkrut@Kruthika"
}

resource "aws_security_group" "webSG" {
  name   = var.sg_name
  vpc_id = aws_vpc.my_vpc.id


  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240927"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id              = aws_subnet.public_subnet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/C/Users/mkrut/.ssh/id_rsa")
    host        = self.public_ip
    timeout     = "5m"
  }


  # User Data script to create the /var/www/html directory
  user_data = <<-EOF
              #!/bin/bash
              echo "Creating /var/www/html directory" >> /var/log/user-data.log
              sudo mkdir -p /var/www/html  
              sudo chown -R ubuntu:ubuntu /var/www/html 
              sudo chmod -R 777 /var/www/html
              EOF


  # Remote-exec provisioner: Install Nginx and start the server
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "/var/www/html/index.html"
  }

}
