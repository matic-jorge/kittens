resource "aws_codebuild_project" "kittens" {
  name           = "kittens"
  description    = "Project to handle the kittens application"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = aws_iam_role.builder.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://${element(aws_vpc_endpoint.codecommit.dns_entry, length(aws_vpc_endpoint.codecommit.dns_entry) - 1)["dns_name"]}/v1/repos/${aws_codecommit_repository.kittens.repository_name}"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets_ids
    security_group_ids = var.security_group_ids
  }

  tags = {
    Environment = "Test"
  }
}
