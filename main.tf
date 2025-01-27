provider "aws" {
  region = "ap-northeast-2"
}

# VPC 생성
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "test-igw"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_d" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2c"
  tags = {
    Name = "public-subnet-2"
  }
}

# NAT 게이트웨이를 위한 Elastic IP 생성
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "nat-eip"
  }
}

# NAT 게이트웨이 생성 (퍼블릭 서브넷에 배치)
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "my-nat-gateway"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_subnet" "private_subnet_d" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private-subnet-4"
  }
}

# 퍼블릭 라우팅 테이블 생성
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

# 퍼블릭 라우팅 테이블에 IGW 추가
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# 퍼블릭 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_d_association" {
  subnet_id      = aws_subnet.public_subnet_d.id
  route_table_id = aws_route_table.public_route_table.id
}

# 프라이빗 라우팅 테이블 생성
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# 프라이빗 라우팅 테이블에 NAT 게이트웨이 추가
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# 프라이빗 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_d_association" {
  subnet_id      = aws_subnet.private_subnet_d.id
  route_table_id = aws_route_table.private_route_table.id
}
