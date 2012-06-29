require 'metriks'

module Metriks
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      time_response(env) do
        record_backlog env
        call_downstream env
      end
    end

  protected

    def time_response(env, &block)
      if env.has_key? 'async.close'
        context = response_timer.time
        env['async.close'].callback do p('stop'); context.stop end
        block.call
      else
        response_timer.time &block
      end
    end

    def record_backlog(env)
      backlog_wait = env['HTTP_X_HEROKU_QUEUE_WAIT_TIME']
      return unless backlog_wait

      backlog_wait = backlog_wait.to_f / 1000.0
      backlog_recorder.update(backlog_wait)
    end

    def call_downstream(env)
      @app.call env
    end

    def response_timer
      Metriks.timer 'viso'
    end

    def backlog_recorder
      Metriks.histogram 'viso.backlog'
    end
  end
end
