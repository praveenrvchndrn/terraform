# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name: "demo"
  }
  
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "mainrt" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "mainrt"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.mainrt.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.demo.id

  ingress {
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

  tags = {
    Name = "main_sg"
  }
}

resource "aws_instance" "main" {
  ami           = "ami-0c614dee691cbbf37"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.main.id]
  associate_public_ip_address = true

  tags = {
    Name = "main_instance_with_public_ip"
  }
}


