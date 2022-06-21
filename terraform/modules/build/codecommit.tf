resource "aws_codecommit_repository" "kittens" {
  repository_name = "kittens"
  default_branch  = "main"
}

resource "aws_vpc_endpoint" "codecommit" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.git-codecommit"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = var.subnets_ids
  private_dns_enabled = true
  tags = {
    "Name" = "codecommit"
  }
}
