data "aws_iam_policy_document" "trigger" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "deploy_trigger_inline_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "codecommit:GetTree",
      "codecommit:BatchGetCommits",
      "codecommit:GetCommit",
      "codecommit:GetCommitHistory",
      "codecommit:GetDifferences",
      "codecommit:GetReferences",
      "codecommit:GetObjectIdentifier",
      "codecommit:BatchGetCommits"
    ]
    effect    = "Allow"
    resources = [var.codecommit_repository_arn]
  }
  statement {
    actions   = ["codebuild:StartBuild"]
    effect    = "Allow"
    resources = [var.codebuild_project_arn]
  }
}

resource "aws_iam_role" "deploy_trigger" {
  name               = "deploy_trigger"
  path               = "/terraform/deploy/"
  assume_role_policy = data.aws_iam_policy_document.trigger.json
}

resource "aws_iam_role_policy" "triger_policy" {
  role = aws_iam_role.deploy_trigger.name

  policy = data.aws_iam_policy_document.deploy_trigger_inline_policy.json
}
