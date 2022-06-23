variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "subnets_arns" {
  type        = list(string)
  description = "List of subnets ARN to allow the build"
}

variable "build_buckets_arn" {
  type        = list(string)
  description = "List of buckets ARN to use with the build"
}

variable "vpc_id" {
  type        = string
  description = "VPC in which the build will happen"
}

variable "subnets_ids" {
  type        = list(string)
  description = "List of IDs of the codebuild subnets"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of the ID of security groups"
}

variable "codebuild_role_arn" {
  type = string
  description = "ARN of the role to use in codebuild"
}

variable "codecommit_repository_name" {
  type = string
  description = "Name of the CodeCommit repository"
}
