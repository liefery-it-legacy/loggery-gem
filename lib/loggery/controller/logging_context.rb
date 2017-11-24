module Loggery
  module Controller
    module LoggingContext
      extend ActiveSupport::Concern

      included do
        before_action :set_logging_metadata
      end

      class_methods do
        def log_context(&block)
          @@loggery_log_context_block = block
        end
      end

      def set_logging_metadata
        return unless Loggery::Metadata::Store.store

        log_options = { worker_type: "web" }
        log_options.merge! instance_eval(&@@loggery_log_context_block) if @@loggery_log_context_block

        Loggery::Metadata::Store.store.merge!(log_options)
      end
    end
  end
end
