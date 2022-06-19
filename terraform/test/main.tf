module "aws_infra" {
  source = "../modules/environment"

  environment           = local.environment
  cidr                  = local.cidr
  daily_driver          = var.daily_driver
  daily_driver_ssh_file = var.daily_driver_ssh_file
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

  subnets_arns       = module.aws_infra.codebuild_subnet_arns
  build_buckets_arn  = []
  vpc_id             = module.aws_infra.vpc_id
  subnets_ids        = module.aws_infra.codebuild_subnet_ids
  security_group_ids = [module.aws_infra.build_sg_id]

}
