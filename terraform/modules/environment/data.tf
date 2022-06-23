data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "local_file" "daily_driver_ssh_pub_key" {
  filename = var.daily_driver_ssh_file
}
