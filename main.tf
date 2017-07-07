provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}


# Public Subnets
resource "aws_subnet" "public-subnet-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public-subnet-cidr-a}"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public-subnet-cidr-b}"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "public-subnet-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public-subnet-cidr-c}"
  availability_zone = "${var.region}c"
}

resource "aws_route_table" "public-subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public-subnet-route" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.igw.id}"
  route_table_id          = "${aws_route_table.public-subnet-route-table.id}"
}

resource "aws_route_table_association" "public-subnet-a-route-table-association" {
  subnet_id      = "${aws_subnet.public-subnet-a.id}"
  route_table_id = "${aws_route_table.public-subnet-route-table.id}"
}

resource "aws_route_table_association" "public-subnet-b-route-table-association" {
  subnet_id      = "${aws_subnet.public-subnet-b.id}"
  route_table_id = "${aws_route_table.public-subnet-route-table.id}"
}

resource "aws_route_table_association" "public-subnet-c-route-table-association" {
  subnet_id      = "${aws_subnet.public-subnet-c.id}"
  route_table_id = "${aws_route_table.public-subnet-route-table.id}"
}


# Private subnets
resource "aws_subnet" "private-subnet-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private-subnet-cidr-a}"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private-subnet-cidr-b}"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "private-subnet-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private-subnet-cidr-c}"
  availability_zone = "${var.region}c"
}

resource "aws_route_table" "private-subnet-a-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "private-subnet-b-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "private-subnet-c-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table_association" "private-subnet-a-route-table-association" {
  subnet_id         = "${aws_subnet.private-subnet-a.id}"
  route_table_id    = "${aws_route_table.private-subnet-a-route-table.id}"
}

resource "aws_route_table_association" "private-subnet-b-route-table-association" {
  subnet_id         = "${aws_subnet.private-subnet-b.id}"
  route_table_id    = "${aws_route_table.private-subnet-b-route-table.id}"
}

resource "aws_route_table_association" "private-subnet-c-route-table-association" {
  subnet_id         = "${aws_subnet.private-subnet-c.id}"
  route_table_id    = "${aws_route_table.private-subnet-c-route-table.id}"
}


# Nginx
resource "aws_instance" "instance" {
  ami           = "ami-cdbfa4ab"
  instance_type = "t2.small"
  vpc_security_group_ids      = [ "${aws_security_group.security-group.id}" ]
  subnet_id                   = "${aws_subnet.public-subnet-a.id}"
  associate_public_ip_address = true
  key_name                    = "terraform" # this must be created before running terraform
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

resource "aws_security_group" "security-group" {
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port = "80"
      to_port   = "80"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = "443"
      to_port   = "443"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "nginx_domain" {
  value = "${aws_instance.instance.public_dns}"
}
