# frozen_string_literal: true

module Loggery
  module Shoryuken
    module Setup
      def self.setup
        ::Shoryuken.configure_server do |config|
          config.server_middleware do |chain|
            chain.add Loggery::Metadata::Middleware::Shoryuken
          end
        end
      end
    end
  end
end
