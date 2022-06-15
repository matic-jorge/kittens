variable "subnets_arn" {
  type        = list(string)
  description = "List of subnets ARN to allow the build"
}

variable "build_buckets_arn" {
  type        = list(string)
  description = "List of buckets ARN to use with the build"
}
