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
        record_backlog env
        @app.call env
      end
    end

  protected

    def record_backlog(env)
      backlog_wait = env['HTTP_X_HEROKU_QUEUE_WAIT_TIME']
      return unless backlog_wait

      backlog_wait = backlog_wait.to_f / 1000.0
      @backlog.update backlog_wait
    end
  end
end
