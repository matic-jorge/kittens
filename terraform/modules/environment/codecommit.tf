resource "aws_codecommit_repository" "kittens" {
  repository_name = "kittens"
  default_branch  = "main"
}
