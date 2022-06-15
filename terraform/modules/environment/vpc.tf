data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

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
    Name        = var.environment
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

output "db_subnet_group_data" {
  value = {
    name = aws_db_subnet_group.default.name
    id   = aws_db_subnet_group.default.id
  }

}
