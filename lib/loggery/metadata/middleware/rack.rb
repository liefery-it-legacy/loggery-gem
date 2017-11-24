# frozen_string_literal: true
module Loggery
  module Metadata
    module Middleware
      class Rack
        def initialize(app)
          @app = app
        end

        def call(env)
          Loggery::Metadata::Store.with_metadata(request_id: env["action_dispatch.request_id"]) do
            @app.call(env)
          end
        end
      end
    end
  end
end