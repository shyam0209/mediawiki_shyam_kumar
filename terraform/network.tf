## VPC Creation
resource "aws_vpc" "mediavpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "mediavpc"
  }
}

## Public Subnet
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.mediavpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    Name = "mediavpc-subnet-public"
  }
}

## IGW creation for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mediavpc.id
  tags = {
    Name = "mediavpc-igw"
  }
}

## Route Table creation
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.mediavpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "media-public-rt"
  }
}

## Attaching RT to subnet
resource "aws_route_table_association" "public-subnet-assoc" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table.id
}

## SG with ssh and http connection

resource "aws_security_group" "media_web" {
  name        = "WebSG"
  description = "SG for Mediawiki instance"
  vpc_id      = aws_vpc.mediavpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.http_range]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_range]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WebSG"
  }
}



