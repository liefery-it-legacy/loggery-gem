# frozen_string_literal: true

# Logs an exception and a sidekiq context hash in logstash compatible form

class SidekiqExceptionLogger
  def call(exception, context_hash)
    Sidekiq.logger.warn(class: exception.class.name, message: exception.message, context: context_hash.inspect)
  end
end
