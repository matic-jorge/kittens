data "archive_file" "trigger_zip_file" {
  type             = "zip"
  source_file      = "${path.module}/code/lambda.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/code/lambda.zip"
}

resource "aws_lambda_function" "codecommit_trigger" {
  function_name    = "codecommit_trigger"
  filename         = data.archive_file.trigger_zip_file.output_path
  handler          = "lambda_handler"
  role             = aws_iam_role.deploy_trigger.arn
  source_code_hash = data.archive_file.trigger_zip_file.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      CODE_BUILD_PROJECT = var.codebuild_project_arn
    }
  }
}

resource "aws_lambda_permission" "allow_codecommit" {
  statement_id  = "AllowExecutionFromCodeCommit"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codecommit_trigger.function_name
  principal     = "codecommit.amazonaws.com"
  source_arn    = var.codecommit_repository_arn
}
