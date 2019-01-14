# frozen_string_literal: true

# a minimal rails app for specs

class TestRailsApp < Rails::Application
  config.root = File.expand_path("..", __dir__)

  Loggery::LoggerySetup.setup(self)
  config.loggery.enabled = true

  config.cache_classes = true
  config.eager_load = false
end

ENV["RAILS_ENV"] = "test"
ENV["DATABASE_URL"] = "sqlite3://localhost/:memory:"

TestRailsApp.initialize!
