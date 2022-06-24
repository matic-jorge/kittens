resource "heroku_app" "kittens" {
  name   = "jmillan-kittens-${var.environment}"
  region = "us"

  stack = "container"
}
