# frozen_string_literal: true

require 'spec_helper'

module Loggery
  module Controller
    describe LoggingContext do
      describe 'when included' do
        class Spy
          cattr_accessor :before_action_set

          def self.before_action(action_name)
            Spy.before_action_set = true if action_name == :loggery_set_metadata
          end

          include LoggingContext
          log_context { { foo: :bar } }
        end

        before { Loggery::Metadata::Store.init_store }

        it 'registers a before_action' do
          expect(Spy.before_action_set).to be_truthy
        end

        it 'accepts custom log context' do
          Spy.new.loggery_set_metadata
          expect(Loggery::Metadata::Store.store).to include(foo: :bar)
        end
      end
    end
  end
end
