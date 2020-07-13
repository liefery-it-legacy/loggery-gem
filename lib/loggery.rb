# frozen_string_literal: true

require "lograge"
require "logstash-event"
require "logstash-logger"
require "rails"

require "loggery/gem/version"
require "loggery/util"
require "loggery/controller/logging_context"
require "loggery/sidekiq/setup"
require "loggery/sidekiq/sidekiq_exception_logger"
require "loggery/shoryuken/setup"
require "loggery/metadata/logstash_event_util"
require "loggery/metadata/store"
require "loggery/metadata/middleware/rack"
require "loggery/metadata/middleware/sidekiq"
require "loggery/metadata/middleware/shoryuken"
require "loggery/railtie"

module Loggery
  def self.setup_sidekiq
    Loggery::Sidekiq::Setup.setup
  end

  def self.setup_shoryuken
    Loggery::Shoryuken::Setup.setup
  end
end
