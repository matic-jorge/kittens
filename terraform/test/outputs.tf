output "db_connection_string" {
  value     = module.db.db_connection_string
  sensitive = true
}
