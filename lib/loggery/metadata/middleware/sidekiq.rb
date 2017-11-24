# frozen_string_literal: true
module Loggery
  module Metadata
    module Middleware
      class Sidekiq
        include Loggery::Util

        # Clients can provide their own error handler
        cattr_accessor(:error_handler) { ->(e){ Sidekiq::Logging.logger.error(e) } }

        def initialize(options = nil)
        end

        def call(_worker, msg, queue)
          Loggery::Metadata::Store.with_metadata(jid:         msg["jid"],
                                                 thread_id:   Thread.current.object_id.to_s(36),
                                                 worker:      msg["class"],
                                                 args:        msg["args"].inspect,
                                                 queue:       queue,
                                                 retry_count: msg["retry_count"],
                                                 worker_type: "sidekiq") do
            log_job_runtime(:sidekiq_job, "#{msg['class']} (#{msg['args']})") do
              begin
                yield
              rescue => e
                @@error_handler.call(e) if @@error_handler
                raise e
              end
            end
          end
        end
      end
    end
  end
end
