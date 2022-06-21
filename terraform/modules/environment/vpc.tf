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

resource "aws_subnet" "db" {
  for_each          = { 0 = 0, 1 = 1 }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 12, each.value)
  availability_zone = data.aws_availability_zones.available.names[each.value]

  tags = {
    Name        = "${var.environment}-db"
    environment = var.environment
  }
}

resource "aws_subnet" "codebuild" {
  for_each          = { 0 = 0, 1 = 1 }
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
