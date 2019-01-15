# frozen_string_literal: true

# Rack middleware that adds basic request metadata to all log lines.

module Loggery
  module Metadata
    module Middleware
      class Rack
        def initialize(app)
          @app = app
        end

        def call(env)
          Loggery::Metadata::Store.with_metadata(worker_type: "web",
                                                 request_id:  env["action_dispatch.request_id"]) do
            @app.call(env)
          end
        end
      end
    end
  end
end
