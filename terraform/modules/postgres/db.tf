resource "aws_db_instance" "kittens" {
  identifier           = "kittens-${var.environment}"
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "db.t3.micro"
  username             = var.db_master_user
  password             = var.db_master_password
  skip_final_snapshot  = true
  db_subnet_group_name = var.subnet_group_name
  publicly_accessible  = true
}
