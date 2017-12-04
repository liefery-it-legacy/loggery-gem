# frozen_string_literal: true

require "spec_helper"

module Loggery
  module Controller
    describe LoggingContext do
      describe "when included" do
        class self::Spy
          class << self
            cattr_accessor :before_action_set

            def before_action(action_name)
              self.before_action_set = true if action_name == :loggery_set_metadata
            end
          end

          include LoggingContext
          def loggery_log_context
            { foo: :bar }
          end
        end

        before { Loggery::Metadata::Store.init_store }

        it "registers a before_action" do
          expect(self.class::Spy.before_action_set).to be_truthy
        end

        it "accepts custom log context" do
          self.class::Spy.new.loggery_set_metadata
          expect(Loggery::Metadata::Store.store).to include(foo: :bar)
        end
      end
    end
  end
end
