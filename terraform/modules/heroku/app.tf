resource "heroku_app" "test" {
  name   = "jmillan-kittens-test"
  region = "us"

  stack = "container"
}
