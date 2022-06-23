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

variable "cidr" {
  type        = string
  description = "CIDR for the environment"
}

variable "environment" {
  type        = string
  description = "The environment to create"
}

variable "daily_driver" {
  type        = string
  description = "Username to use as the daily driver"
}

variable "daily_driver_ssh_file" {
  type        = string
  description = "Full path for the ssh pub key for the daily driver"
}
