# frozen_string_literal: true

# Logs an exception and a sidekiq context hash in logstash compatible form

class SidekiqExceptionLogger
  def call(ex, ctx_hash)
    Sidekiq.logger.warn(class: ex.class.name, message: ex.message, context: ctx_hash.inspect)
  end
end
