resource "aws_iam_user" "daily_driver" {
  name = var.daily_driver
  path = "/"
}

resource "aws_iam_user_ssh_key" "daily_driver" {
  username   = aws_iam_user.daily_driver.name
  encoding   = "SSH"
  public_key = data.local_file.daily_driver_ssh_pub_key.content
}

data "aws_iam_policy_document" "builder" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "codebuild.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "builder_inline_policy" {
  policy_id = "builder"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*"
    ]
    condition {
      test     = "ArnEquals"
      variable = "ec2:Subnet"
      values   = [for subnet in aws_subnet.codebuild : subnet.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }
  statement {
    actions = [
      "codecommit:GitPull"
    ]
    effect = "Allow"
    resources = [
      aws_codecommit_repository.kittens.arn
    ]
  }
}

resource "aws_iam_role" "builder" {
  name               = "builder"
  path               = "/terraform/build/"
  assume_role_policy = data.aws_iam_policy_document.builder.json
}

resource "aws_iam_role_policy" "builder_policy" {
  role = aws_iam_role.builder.name

  policy = data.aws_iam_policy_document.builder_inline_policy.json
}

resource "aws_iam_instance_profile" "builder" {
  name = "builder"
  role = aws_iam_role.builder.name
}

