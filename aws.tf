resource "aws_vpc" "postfix-vpc" {
  count = var.AWS_RESOURCES ? 1 : 0
  cidr_block = var.VPN_RANGE
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "postfix-subnet" {
  count = var.AWS_RESOURCES ? 1 : 0
  cidr_block = var.SUBNET_RANGE
  vpc_id = aws_vpc.postfix-vpc[0].id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "postfix-igw" {
  count = var.AWS_RESOURCES ? 1 : 0
  vpc_id = aws_vpc.postfix-vpc[0].id
}

resource "aws_route_table" "postfix-rt" {
  count = var.AWS_RESOURCES ? 1 : 0
  vpc_id = aws_vpc.postfix-vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.postfix-igw[0].id
  }
}

resource "aws_route_table_association" "postfix-rt-association" {
  count = var.AWS_RESOURCES ? 1 : 0
  route_table_id = aws_route_table.postfix-rt[0].id
  subnet_id = aws_subnet.postfix-subnet[0].id
}

resource "aws_security_group" "postfix-sg" {
  count = var.AWS_RESOURCES ? 1 : 0
  name = "allow_smtp_http_and_ssh"
  description = "Allow SMTP, HTTP/S and SSH traffic"
  vpc_id = aws_vpc.postfix-vpc[0].id

  ingress {
    description = "SSH access"
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP 80 access"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS 443 access"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTP"
    to_port = 25
    protocol = "tcp"
    from_port = 25
  }

  ingress {
    description = "GOPHISH"
    to_port = 3333
    protocol = "tcp"
    from_port = 3333
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aws_server" {
  count = var.AWS_RESOURCES ? 1 : 0
  ami                         = "ami-08a51b561b4f546fc"
  instance_type               = "t2.small"
  user_data                   = data.template_file.user_data.rendered
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.postfix-sg[0].id]
  subnet_id                   = aws_subnet.postfix-subnet[0].id

  tags = {
    Name = "aws_postfix_${count.index}"
  }
}
