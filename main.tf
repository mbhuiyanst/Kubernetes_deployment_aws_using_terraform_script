provider "aws" {
  region = var.region
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "k8s-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "k8s-public-rt"
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.k8s_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("my-key.pub")
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "k8s_subnet" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Allow all traffic within cluster"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.k8s_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  

  tags = {
    Name = "k8s-master"
  }
}




resource "aws_instance" "workers" {
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.k8s_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}
  