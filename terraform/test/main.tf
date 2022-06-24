module "aws_infra" {
  source = "../modules/environment"

  environment           = local.environment
  cidr                  = local.cidr
  daily_driver          = var.daily_driver
  daily_driver_ssh_file = var.daily_driver_ssh_file

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
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

  subnets_arns               = module.aws_infra.codebuild_subnet_arns
  build_buckets_arn          = []
  vpc_id                     = module.aws_infra.vpc_id
  subnets_ids                = module.aws_infra.codebuild_subnet_ids
  security_group_ids         = [module.aws_infra.build_sg_id]
  codebuild_role_arn         = module.aws_infra.codebuild_role_arn
  codecommit_repository_name = module.aws_infra.codecommit_repository_name

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}

module "trigger" {
  source = "../modules/trigger"

  codecommit_repository_name = module.aws_infra.codecommit_repository_name
  codecommit_repository_arn  = module.aws_infra.codecommit_repository_arn
  codebuild_project_arn      = module.build.codebuild_project_arn

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}

module "heroku" {
  source = "../modules/heroku"

  environment          = local.environment
  db_connection_string = module.db.db_connection_string

  heroku_email   = var.heroku_email
  heroku_api_key = var.heroku_api_key
}
