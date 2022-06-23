data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.environment
    environment = var.environment
  }
}

resource "aws_subnet" "gateway" {
  for_each          = { 0 = 0 }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 12, each.value)
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name        = "${var.environment}-gateway"
    environment = var.environment
  }
}

resource "aws_subnet" "db" {
  for_each          = { 0 = 1, 1 = 2 }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 12, each.value)
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name        = "${var.environment}-db"
    environment = var.environment
  }
}

resource "aws_subnet" "codebuild" {
  for_each          = { 0 = 2, 1 = 3 }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 12, each.value + 2)
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name        = "${var.environment}-codebuild"
    environment = var.environment
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.db : subnet.id]

  tags = {
    Name        = var.environment
    environment = var.environment
  }
}

data "aws_security_group" "default" {
  vpc_id = aws_vpc.main.id
  name   = "default"
}

resource "aws_security_group" "build" {
  name   = "build"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "build_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.build.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = var.environment
    environment = var.environment
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "gateway-${var.environment}"
    environment = var.environment
  }
}

resource "aws_route_table" "build" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.gateway.primary_network_interface_id
  }

  route {
    ipv6_cidr_block      = "::/0"
    network_interface_id = aws_instance.gateway.primary_network_interface_id
  }

  tags = {
    Name        = "build-${var.environment}"
    environment = var.environment
  }
}

resource "aws_route_table_association" "build" {
  for_each       = aws_subnet.codebuild
  subnet_id      = each.value.id
  route_table_id = aws_route_table.build.id
}
