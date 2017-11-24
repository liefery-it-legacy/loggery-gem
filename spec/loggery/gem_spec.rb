require "spec_helper"

RSpec.describe Loggery::Gem do
  it "has a version number" do
    expect(Loggery::Gem::VERSION).not_to be nil
  end
end
