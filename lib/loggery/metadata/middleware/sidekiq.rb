# frozen_string_literal: true

# Sidekiq middleware that adds basic sidekiq metadata to all log lines.

module Loggery
  module Metadata
    module Middleware
      class Sidekiq
        include Loggery::Util

        # Clients can provide their own error handler
        class << self
          attr_accessor(:error_handler) { ->(e) { Sidekiq::Logging.logger.error(e) } }
        end

        def call(_worker, message, queue)
          Loggery::Metadata::Store.with_metadata(build_metadata(message, queue)) do
            job_instance_name = "#{message['class']} (#{message['args']})"
            log_job_start(message, job_instance_name)

            log_job_runtime(:sidekiq_job, job_instance_name) do
              yield
            rescue StandardError => e
              # Log exceptions here, otherwise they won't have the metadata available anymore by
              # the time they reach the Sidekiq default error handler.
              self.class.error_handler&.call(e)
              raise e
            end
          end
        end

        private

        def build_metadata(message, queue)
          {
            jid:         message["jid"],
            thread_id:   Thread.current.object_id.to_s(36),
            worker:      message["class"],
            args:        message["args"].inspect,
            queue:       queue,
            retry_count: message["retry_count"],
            worker_type: "sidekiq"
          }
        end

        def log_job_start(message, job_instance_name)
          execution_delay =
            (Time.current - Time.zone.at(message["enqueued_at"]) if message["enqueued_at"])

          Rails.logger.info(
            event_type:      :sidekiq_job_started,
            message:         "Job type sidekiq_job - #{job_instance_name} started",
            execution_delay: execution_delay
          )
        end
      end
    end
  end
end
