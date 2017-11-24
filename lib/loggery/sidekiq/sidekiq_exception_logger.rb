# frozen_string_literal: true

class SidekiqExceptionLogger
  def call(ex, ctx_hash)
    Sidekiq.logger.warn(class: ex.class.name, message: ex.message, context: ctx_hash.inspect)
  end
end