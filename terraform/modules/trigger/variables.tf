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

variable "codecommit_repository_name" {
  type        = string
  description = "CodeCommit repository name"
}

variable "codecommit_repository_arn" {
  type        = string
  description = "ARN of the codecommit repository"
  sensitive   = true
}

variable "codebuild_project_arn" {
  type        = string
  description = "ARN of the codebuild project"
  sensitive   = true
}

