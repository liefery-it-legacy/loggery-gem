# frozen_string_literal: true
require "spec_helper"

describe Loggery::Metadata::Store do
  subject { described_class }

  describe ".with_metadata" do
    it "initializes the store" do
      subject.with_metadata({}) do
        expect(Loggery::Metadata::Store.store).to be_a Hash
      end
    end

    it "adds the given metadata to the store" do
      subject.with_metadata(foo: :bar) do
        expect(Loggery::Metadata::Store.store[:foo]).to eq :bar
      end
    end

    it "closes the store afterwards" do
      subject.with_metadata({}) {}
      expect(Loggery::Metadata::Store.store).to eq nil
    end
  end
end
