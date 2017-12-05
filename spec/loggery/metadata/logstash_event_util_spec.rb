# frozen_string_literal: true

require "spec_helper"

describe Loggery::Metadata::LogstashEventUtil do
  subject { described_class }

  describe ".set_logstash_event_metadata" do
    let(:event) { LogStash::Event.new }

    [:type, "type", :uid, "uid", :_routing, "_routing"].each do |magic_field|
      context "reserved field #{magic_field}" do
        it "raises an exception" do
          expect do
            subject.set_logstash_event_metadata(event, magic_field => :foo)
          end.to raise_error(/'#{magic_field}' is a reserved field name/)
        end
      end
    end
  end
end
