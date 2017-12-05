# frozen_string_literal: true

require "active_support/concern"

# Provides a hook in Rails controllers that allows enriching log lines from within a Rails request
# with data that is available only within a controller action, for instance user information.

module Loggery
  module Controller
    module LoggingContext
      extend ActiveSupport::Concern

      included do
        before_action :loggery_set_metadata
      end

      # to be overridden in including class
      def loggery_log_context
        {}
      end

      def loggery_set_metadata
        return unless Loggery::Metadata::Store.store
        metadata = loggery_default_metadata.merge loggery_log_context
        Loggery::Metadata::Store.store.merge!(metadata)
      end

      def loggery_default_metadata
        {}
      end
    end
  end
end
