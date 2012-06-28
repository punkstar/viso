require 'metriks'

module Metriks
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Metriks.timer('viso').time do
        @app.call env
      end
    end
  end
end
