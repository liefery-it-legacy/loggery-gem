# frozen_string_literal: true

require 'bundler/setup'
require_relative 'support/test_rails_app'
require 'pry'

require 'loggery'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
