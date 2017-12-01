# frozen_string_literal: true

# Provides a hook in Rails controllers that allows enriching log lines from within a Rails request
# with data that is available only within a controller action, for instance user information.

module Loggery
  module Controller
    module LoggingContext
      extend ActiveSupport::Concern

      included do
        before_action :loggery_set_metadata
      end

      class_methods do
        cattr_accessor :loggery_log_context_block

        def log_context(&block)
          self.loggery_log_context_block = block
        end
      end

      def loggery_set_metadata
        return unless Loggery::Metadata::Store.store
        metadata = loggery_default_metadata.merge loggery_custom_metadata
        Loggery::Metadata::Store.store.merge!(metadata)
      end

      def loggery_default_metadata
        {}
      end

      def loggery_custom_metadata
        loggery_log_context_block = self.class.loggery_log_context_block
        loggery_log_context_block ? instance_eval(&loggery_log_context_block) : {}
      end
    end
  end
end
