output "db_subnet_group_data" {
  value = {
    name = aws_db_subnet_group.default.name
    id   = aws_db_subnet_group.default.id
  }
}

output "codebuild_subnet_ids" {
  value = [for subnet in aws_subnet.codebuild : subnet.id]
}

output "codebuild_subnet_arns" {
  value = [for subnet in aws_subnet.codebuild : subnet.arn]
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "default_sg_id" {
  value = data.aws_security_group.default.id
}

output "build_sg_id" {
  value = aws_security_group.build.id
}

output "codebuild_role_arn" {
  value = aws_iam_role.builder.arn
}

output "codecommit_repository_name" {
  value = aws_codecommit_repository.kittens.repository_name
}

output "codecommit_repository_arn" {
  value = aws_codecommit_repository.kittens.arn
}

output "ssh_key_id" {
  value = aws_iam_user_ssh_key.daily_driver.ssh_public_key_id
}