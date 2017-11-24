# Loggery Gem

Make your Rails app produce [Logstash](https://www.elastic.co/products/logstash) compatible log
files that can be used for structured, centralized logging in
[Kibana](https://www.elastic.co/products/kibana).

This is a convenience gem that heavily builds on previous work by
[Lograge](https://github.com/roidrage/lograge) by
[roidrage](https://github.com/dwbutler/logstash-logger) and
[logstash-logger](https://github.com/dwbutler/logstash-logger) by
[dwbutler](https://github.com/dwbutler). it mainly connects these gems and sets some useful
defaults.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'loggery'
```

And then execute:

    $ bundle

### Basic Rails integration
```ruby
config.loggery.enabled = true
```

to your `config/application.rb`.

### Add user metadata to logs

If you would like to enrich your log records with information about the active user, add this to
your `ApplicationController`:

```ruby
include Loggery::Controller::LoggingContext
log_context do
  { 
    user_id: current_user.try(:id), 
    user_email: current_user.try(:email)
  }
end
```

The above example assumes you are using devise and your would like to log the `id` and `email` of
your user. You can adapt this block to include whichever information you would like to add to your
log records.

### Sidekiq

If you're using Sidekiq you can enable structured logging in sidekiq by adding these lines to 
`config/initializers/sidekiq.rb`:

```ruby
Sidekiq.configure_server do |config|
  Loggery.setup_sidekiq!(config)
end

Sidekiq::Logging.logger = Rails.logger
```

This will make sure that useful metadata like the sidekiq job id, the thread id, the worker type,
its arguments, the retry count, job runtime, ...

## Usage


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liefery/loggery-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

