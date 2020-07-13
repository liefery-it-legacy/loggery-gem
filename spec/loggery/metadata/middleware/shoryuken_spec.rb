# frozen_string_literal: true

require "spec_helper"

describe Loggery::Metadata::Middleware::Shoryuken do
  let(:body) do
    { 
      "job_class" => "MyWorker",
      "arguments" => [ "foo", "bar" ],
      "enqueued_at" => "2020-07-13T14:25:01Z",
      "executions" => 0
    }
  end

  describe "#call" do
    it "stores data relevant for logging in RequestStore and makes it available within the block" do
      subject.call(nil, "critical", nil, body) do
        expect(Loggery::Metadata::Store.store).to include(
          jid:         anything,
          thread_id:   anything,
          job_class:   "MyWorker",
          arguments:   '["foo", "bar"]',
          queue:       "critical",
          executions:  0,
          worker_type: "shoryuken"
        )
      end
    end

    it "logs the execution delay and duration of the shoryuken request" do
      expect(Rails.logger).to receive(:info)
        .with(event_type:      :shoryuken_job_started,
              message:         'Job type shoryuken_job - MyWorker (["foo", "bar"]) started',
              execution_delay: anything)
        .and_call_original
      expect(Rails.logger).to receive(:info)
        .with(event_type: :shoryuken_job_finished,
              message:    'Job type shoryuken_job - MyWorker (["foo", "bar"]) finished',
              duration:   anything)
        .and_call_original
      subject.call(nil, "critical", nil, body) {}
    end

    context "when the block raises an exception" do
      around(:each) do |example|
        Loggery::Metadata::Middleware::Shoryuken.error_handler = ->(_e) { Rails.logger.error("test") }
        example.run
        Loggery::Metadata::Middleware::Shoryuken.error_handler = nil
      end

      it "logs and re-raises the exception with correct metadata" do
        allow(Rails.logger).to receive(:info)
          .with(event_type: :shoryuken_job_started, message: anything, execution_delay: anything)
          .and_call_original
        allow(Rails.logger).to receive(:info)
          .with(event_type: :shoryuken_job_finished, message: anything, duration: anything)
          .and_call_original
        expect(Rails.logger).to receive(:error).and_call_original
        expect(Loggery::Metadata::LogstashEventUtil).to receive(:event_metadata) {
          expect(Loggery::Metadata::Store.store.keys).to eq %i[
            jid
            thread_id
            job_class
            arguments
            queue
            executions
            worker_type
          ]
        }.at_least(3).times

        expect do
          subject.call(nil, "critical", nil, body) { raise "boom!" }
        end.to raise_error "boom!"
      end
    end
  end
end
