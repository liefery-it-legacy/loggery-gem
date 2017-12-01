# frozen_string_literal: true

# a minimal rails app for specs

require 'rails/all'
require 'lograge'
require 'lograge/railtie'
require 'logstash-event'
require 'logstash-logger'
require 'loggery'
require 'loggery/railtie'

class TestRailsApp < Rails::Application
  config.root = File.expand_path('../..', __FILE__)

  Loggery::LoggerySetup.setup!(self)
  config.loggery.enabled = true

  config.cache_classes = true
  config.eager_load = false
end

ENV['RAILS_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'

TestRailsApp.initialize!
