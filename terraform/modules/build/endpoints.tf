resource "aws_vpc_endpoint" "codecommit" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.git-codecommit"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = var.subnets_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags = {
    "Name" = "codecommit"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = var.subnets_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags = {
    "Name" = "secretsmanager"
  }
}

resource "aws_vpc_endpoint" "logs" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = var.subnets_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags = {
    "Name" = "logs"
  }
}
