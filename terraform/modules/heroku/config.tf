resource "heroku_config" "db" {
  sensitive_vars = {
    DATABASE_URL = var.db_connection_string
  }
}

resource "heroku_config" "environment" {
  vars = {
    RACK_ENV = var.environment
  }
}

resource "heroku_app_config_association" "kittens" {
  app_id = heroku_app.kittens.id

  # If we need more vas, use the merge function
  vars           = heroku_config.environment.vars
  sensitive_vars = heroku_config.db.sensitive_vars
}
