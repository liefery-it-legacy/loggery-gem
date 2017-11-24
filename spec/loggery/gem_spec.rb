require "spec_helper"

RSpec.describe Loggery::Gem do
  it "has a version number" do
    expect(Loggery::Gem::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
