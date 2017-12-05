# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "loggery/gem/version"

Gem::Specification.new do |spec|
  spec.name          = "loggery"
  spec.version       = Loggery::Gem::VERSION
  spec.authors       = ["Simon Stemplinger"]
  spec.email         = ["simon@stem.ps"]

  spec.summary       = "Generate logstash compatible log output from Rails apps."
  spec.homepage      = "https://github.com/liefery/loggery-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lograge", "~> 0.6"
  spec.add_runtime_dependency "logstash-event", "~> 1.2"
  spec.add_runtime_dependency "logstash-logger", "~> 0.25"
  spec.add_runtime_dependency "rails", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "sqlite3"
end
