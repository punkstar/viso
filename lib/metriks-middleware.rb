require 'metriks'

module Metriks
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      prepare_response_timer env
      record_backlog env
      call_downstream env
    end

  protected

    def prepare_response_timer(env)
      timer = Metriks.timer 'viso'
      env['async.close'].callback do timer.stop end
    end

    def record_backlog(env)
      backlog_wait = env['HTTP_X_HEROKU_QUEUE_WAIT_TIME']
      return unless backlog_wait

      backlog_wait = backlog_wait.to_f / 1000.0
      Metriks.histogram('viso.backlog').update(backlog_wait)
    end

    def call_downstream(env)
      @app.call env
    end
  end
end