require 'metriks'

module Metriks
  class Middleware
    def initialize(app)
      @app = app
      @timer = Metriks.timer 'viso'
      @backlog = Metriks.timer 'viso.backlog'
    end

    def call(env)
      @timer.time do
        backlog_wait = env['HTTP_X_HEROKU_QUEUE_WAIT_TIME']
        if backlog_wait
          @backlog.update backlog_wait.to_i
        end
        @app.call env
      end
    end
  end
end
