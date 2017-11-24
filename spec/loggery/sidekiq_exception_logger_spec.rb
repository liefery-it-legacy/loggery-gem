# frozen_string_literal: true
require "spec_helper"
require "sidekiq"

describe SidekiqExceptionLogger do
  let(:exception) { RuntimeError.new "boom" }

  it "serializes the context hash as a string" do
    expect(Sidekiq.logger).to receive(:warn).with(class: "RuntimeError", message: "boom", context: kind_of(String))
    subject.call(exception, a: :hash)
  end
end
