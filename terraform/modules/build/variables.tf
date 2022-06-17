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
