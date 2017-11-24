# frozen_string_literal: true
require "spec_helper"

describe Loggery::Metadata::Middleware::Sidekiq, with_logs: true do
  let(:msg) { { "class" => "MyWorker", "args" => { foo: :bar } } }

  describe "#call" do
    it "stores data relevant for logging in RequestStore and makes it available within the block" do
      subject.call(nil, msg, "critical") do
        expect(Loggery::Metadata::Store.store).to include(
          jid: anything,
          thread_id: anything,
          worker: "MyWorker",
          args: "{:foo=>:bar}",
          queue: "critical",
          retry_count: anything,
          worker_type: "sidekiq"
        )
      end
    end

    it "logs the duration of the sidekiq request" do
      expect(Rails.logger).to receive(:info).with(event_type: :sidekiq_job_started, message: "Job type sidekiq_job - MyWorker ({:foo=>:bar}) started").and_call_original
      expect(Rails.logger).to receive(:info).with(event_type: :sidekiq_job_finished, message: "Job type sidekiq_job - MyWorker ({:foo=>:bar}) finished", duration: anything).and_call_original
      subject.call(nil, msg, "critical") {}
    end

    context "when the block raises an exception" do
      around(:each) do |example|
        Loggery::Metadata::Middleware::Sidekiq.error_handler = ->(e) { Rails.logger.error("test") }
        example.run
        Loggery::Metadata::Middleware::Sidekiq.error_handler = nil
      end

      it "logs and re-raises the exception with correct metadata" do
        allow(Rails.logger).to receive(:info).with(event_type: :sidekiq_job_started, message: anything).and_call_original
        allow(Rails.logger).to receive(:info).with(event_type: :sidekiq_job_finished, message: anything, duration: anything).and_call_original
        expect(Rails.logger).to receive(:error).and_call_original
        expect(Loggery::Metadata::LogstashEventUtil).to receive(:set_event_metadata) {
          expect(Loggery::Metadata::Store.store.keys).to eq [
            :jid,
            :thread_id,
            :worker,
            :args,
            :queue,
            :retry_count,
            :worker_type
          ]
        }.at_least(3).times

        expect {
          subject.call(nil, msg, "critical") { raise "boom!" }
        }.to raise_error "boom!"
      end
    end
  end
end
