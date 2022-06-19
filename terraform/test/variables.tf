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

variable "db_master_user" {
  type        = string
  description = "Name of the master user"
  default     = "salem"
}

variable "db_master_password" {
  type        = string
  description = "Password of the master db user"
  sensitive   = true
}

variable "daily_driver" {
  type        = string
  description = "Username to use as the daily driver"
}

variable "daily_driver_ssh_file" {
  type        = string
  description = "Full path for the ssh pub key for the daily driver"
}