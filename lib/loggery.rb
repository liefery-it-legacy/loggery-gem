# frozen_string_literal: true

require 'loggery/gem/version'
require 'loggery/util'
require 'loggery/controller/logging_context'
require 'loggery/sidekiq/setup'
require 'loggery/sidekiq/sidekiq_exception_logger'
require 'loggery/metadata/logstash_event_util'
require 'loggery/metadata/store'
require 'loggery/metadata/middleware/rack'
require 'loggery/metadata/middleware/sidekiq'
require 'loggery/railtie'

require 'lograge'
require 'logstash-event'
require 'logstash-logger'

module Loggery
  def self.setup_sidekiq!
    Loggery::Sidekiq::Setup.setup!
  end
end
