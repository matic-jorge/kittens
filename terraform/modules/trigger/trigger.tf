resource "aws_codecommit_trigger" "test" {
  repository_name = var.codecommit_repository_name

  trigger {
    name            = "master change"
    branches        = ["main"]
    events          = ["updateReference"]
    destination_arn = aws_lambda_function.codecommit_trigger.arn
  }
}
