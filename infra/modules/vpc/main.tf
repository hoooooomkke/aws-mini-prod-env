locals { name = "${var.project}-${var.env}" }

data "aws_region" "current" {}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name    = local.name
    project = var.project
    env     = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${local.name}-igw" }
}

# 各AZに Public / Private-App / Private-DB を1つずつ
resource "aws_subnet" "public" {
  for_each                = toset(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, index(var.azs, each.key) + 0)
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = { Name = "${local.name}-public-${each.key}" }
}

resource "aws_subnet" "private_app" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, index(var.azs, each.key) + 2)
  availability_zone = each.key
  tags = { Name = "${local.name}-priv-app-${each.key}" }
}

resource "aws_subnet" "private_db" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, index(var.azs, each.key) + 4)
  availability_zone = each.key
  tags = { Name = "${local.name}-priv-db-${each.key}" }
}

# NAT Gateway（最初のAZのPublicに配置）
resource "aws_eip" "nat" { domain = "vpc" }

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[var.azs[0]].id
  tags          = { Name = "${local.name}-natgw" }
  depends_on    = [aws_internet_gateway.igw]
}

# ルートテーブル（Public）
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ルートテーブル（Private-App）
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}

# ルートテーブル（Private-DB）
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id
}
resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}

# Gateway VPC Endpoints（S3 / DynamoDB）
resource "aws_vpc_endpoint" "s3" {
  count             = var.create_s3_gateway_vpce ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_app.id, aws_route_table.private_db.id]
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.create_dynamodb_gateway_vpce ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_app.id, aws_route_table.private_db.id]
}
