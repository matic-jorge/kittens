resource "aws_iam_user" "daily_driver" {
  name = var.daily_driver
  path = "/"
}

data "local_file" "daily_driver_ssh_pub_key" {
  filename = var.daily_driver_ssh_file
}

resource "aws_iam_user_ssh_key" "daily_driver" {
  username   = aws_iam_user.daily_driver.name
  encoding   = "SSH"
  public_key = data.local_file.daily_driver_ssh_pub_key.content
}
