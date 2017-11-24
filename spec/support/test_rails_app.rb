# a minimal rails app for specs

require "rails"
require 'lograge'
require 'lograge/railtie'
require 'logstash-event'
require 'logstash-logger'

class TestRailsApp < Rails::Application
  config.root = File.expand_path("../..", __FILE__)

  config.lograge.enabled                 = true
  config.lograge.keep_original_rails_log = false
  config.lograge.logger                  = Rails.logger
  config.lograge.formatter               = Lograge::Formatters::Logstash.new

  config.lograge.custom_options = ->(_event) do
    { event_type: :request }
  end

  #TODO: move to railtie and eliminate from backend
  config.logstash.type = :file
  config.logstash.path = "/dev/null"
  LogStashLogger.configure do |config|
    config.customize_event do |event|
      Loggery::Metadata::LogstashEventUtil.set_event_metadata(event)
    end
  end

  config.cache_classes = true
  config.eager_load = false

end

ENV["RAILS_ENV"] = "test"
ENV['DATABASE_URL'] = 'sqlite3://localhost/:memory:'

TestRailsApp.initialize!
