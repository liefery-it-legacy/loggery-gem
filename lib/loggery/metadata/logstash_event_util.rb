# frozen_string_literal: true
# Hooks into LogStashLogger and adds the logging metadata that has been collected to the actual
# Logstash event

# frozen_string_literal: true

module Loggery
  module Metadata
    module LogstashEventUtil
      MAGIC_FIELDS = [:type].freeze

      def self.event_metadata(event)
        return unless loglevel_includes_event?(event)
        stored_metadata = Loggery::Metadata::Store.store || {}
        metadata = default_metadata.merge(stored_metadata)
        _event_metadata(event, metadata)
      end

      def self._event_metadata(event, metadata)
        metadata.each { |k, v| event[k] = v }
        warn_if_magic_fields_are_used(event)
      end

      def self.default_metadata
        { pid: Process.pid }
      end

      def self.loglevel_includes_event?(event)
        severity = event['severity'].downcase
        Rails.logger.respond_to?(severity) && Rails.logger.send("#{severity}?")
      end

      def self.warn_if_magic_fields_are_used(event)
        MAGIC_FIELDS.each do |magic_field|
          if event[magic_field.to_s].present? || event[magic_field.to_sym].present?
            raise "'#{magic_field}' is a reserved field name of logstash. it should not be set in a custom event"
          end
        end
      end
    end
  end
end
