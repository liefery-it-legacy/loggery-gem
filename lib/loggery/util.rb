# frozen_string_literal: true

require "active_support/core_ext/time/calculations"

module Loggery
  module Util
    def log_job_runtime(job_type, job_instance_name)
      job_name = "Job type #{job_type} - #{job_instance_name}"

      begin
        start_time = Time.current
        yield if block_given?
      ensure
        end_time = Time.current
        duration = end_time - start_time

        Rails.logger.info event_type: :"#{job_type}_finished",
                          message:    "#{job_name} finished",
                          duration:   duration
      end
    end
  end
end
