# frozen_string_literal: true

module Loggery
  module Metadata
    module Store
      METADATA_KEY = :logging_metadata

      def self.store
        Thread.current[METADATA_KEY]
      end

      def self.with_metadata(metadata)
        init_store
        merge!(metadata)
        yield
      ensure
        close_store
      end

      def self.merge!(metadata)
        store.merge!(metadata)
      end

      def self.init_store
        Thread.current[METADATA_KEY] = {}
      end

      def self.close_store
        Thread.current[METADATA_KEY] = nil
      end
    end
  end
end
