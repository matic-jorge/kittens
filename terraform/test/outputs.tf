output "db_connection_string" {
  value     = module.db.db_connection_string
  sensitive = true
}

output "ssh_key_id" {
  value = module.aws_infra.ssh_key_id
}
