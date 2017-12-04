# frozen_string_literal: true

# Sidekiq middleware that adds basic sidekiq metadata to all log lines.

module Loggery
  module Metadata
    module Middleware
      class Sidekiq
        include Loggery::Util

        # Clients can provide their own error handler
        cattr_accessor(:error_handler) { ->(e) { Sidekiq::Logging.logger.error(e) } }

        def initialize(options = nil); end

        def call(_worker, msg, queue)
          Loggery::Metadata::Store.with_metadata(jid:         msg['jid'],
                                                 thread_id:   Thread.current.object_id.to_s(36),
                                                 worker:      msg['class'],
                                                 args:        msg['args'].inspect,
                                                 queue:       queue,
                                                 retry_count: msg['retry_count'],
                                                 worker_type: 'sidekiq') do
            log_job_runtime(:sidekiq_job, "#{msg['class']} (#{msg['args']})") do
              begin
                yield
              rescue StandardError => e
                # Log exceptions here, otherwise they won't have the metadata available anymore by
                # the time they reach the Sidekiq default error handler.
                @@error_handler&.call(e)
                raise e
              end
            end
          end
        end
      end
    end
  end
end
