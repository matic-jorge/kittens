module "aws_infra" {
  source = "../modules/environment"

  environment = local.environment
  cidr        = local.cidr
}

module "db" {
  source = "../modules/postgres"

  environment        = local.environment
  subnet_group_name  = module.aws_infra.db_subnet_group_data.name
  db_master_password = var.db_master_password
  db_master_user     = var.db_master_user
}

module "build" {
  source = "../modules/build"

  subnets_arn       = []
  build_buckets_arn = []

}