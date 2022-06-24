variable "environment" {
  type        = string
  description = "The environment to create"
}

variable "heroku_email" {
  type        = string
  description = "email for the heroku provider"
  sensitive   = true
}

variable "heroku_api_key" {
  type        = string
  description = "API key for the heroku provider"
  sensitive   = true
}

variable "db_connection_string" {
  type        = string
  description = "The complete connection string (URL) for the db"
  sensitive   = true
}
