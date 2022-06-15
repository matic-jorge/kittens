variable "environment" {
  type        = string
  description = "Environment in which the DB is"
}

variable "db_master_user" {
  type        = string
  description = "Name of the master user"
  default     = "salem"
}

variable "db_master_password" {
  type        = string
  description = "Password for the master user"
  sensitive   = true
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the DB subnet group"
}
