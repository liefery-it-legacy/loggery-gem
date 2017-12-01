# frozen_string_literal: true

module Loggery
  module Sidekiq
    module Setup
      def self.setup!
        Sidekiq::Logging.logger = Rails.logger

        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add Loggery::Metadata::Middleware::Sidekiq
          end

          # Sidekiq by default logs deeply nested json which throws off the json logger and elasticsearch.
          # We therefore want to use our own logger that serializes this hash
          config.error_handlers.clear
          config.error_handlers << SidekiqExceptionLogger.new
        end
      end
    end
  end
end
