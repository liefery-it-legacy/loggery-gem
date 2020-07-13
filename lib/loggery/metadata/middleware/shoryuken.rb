# frozen_string_literal: true

# Shoryuken middleware that adds basic metadata to all log lines.

module Loggery
  module Metadata
    module Middleware
      class Shoryuken
        include Loggery::Util

        # Clients can provide their own error handler
        class << self
          attr_accessor(:error_handler) { ->(e) { Rails.logger.error(e) } }
        end

        def call(worker_instance, queue, sqs_msg, body)
          Loggery::Metadata::Store.with_metadata(build_metadata(queue, body)) do
            job_instance_name = "#{body['job_class']} (#{body['arguments']})"
            log_job_start(body, job_instance_name)

            log_job_runtime(:shoryuken_job, job_instance_name) do
              yield
            rescue StandardError => e
              # Log exceptions here, otherwise they won't have the metadata available anymore by
              # the time they reach the Shoryuken default error handler.
              self.class.error_handler&.call(e)
              raise e
            end
          end
        end

        private

        def build_metadata(queue, body)
          {
            jid:         body["job_id"],
            thread_id:   Thread.current.object_id.to_s(36),
            job_class:   body["job_class"],
            arguments:   body["arguments"].inspect,
            queue:       queue,
            executions:   body["executions"],
            worker_type: "shoryuken",
          }
        end

        def log_job_start(body, job_instance_name)
          execution_delay =
            (Time.current - Time.zone.parse(body["enqueued_at"]) if body["enqueued_at"])

          Rails.logger.info(
            event_type:      :shoryuken_job_started,
            message:         "Job type shoryuken_job - #{job_instance_name} started",
            execution_delay: execution_delay
          )
        end
      end
    end
  end
end
