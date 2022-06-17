output "db_connection_string" {
  value     = "postgres://${var.db_master_user}:${var.db_master_password}@${aws_db_instance.kittens.address}:5432/kittens"
  sensitive = true
}
