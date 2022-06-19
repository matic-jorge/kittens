output "db_connection_string" {
  value     = module.db.db_connection_string
  sensitive = true
}

output "codecommit_ssh_clone" {
  value = module.build.codecommit_ssh
}
