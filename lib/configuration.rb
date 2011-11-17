require 'jammit_helper'
require 'sinatra/respond_with'

module Configuration

  def self.inject(base)
    Configurer.new(base).instance_eval do
      add_new_relic_instrumentation
      catch_errors_with_hoptoad
      handle_requests_using_fiber_pool

      register_response_and_view_helpers
      serve_public_assets
      vary_all_responses_on_accept_header
    end
  end

  class << self
    alias_method :registered, :inject
  end

  class Configurer
    def initialize(base)
      @base = base
    end

    def add_new_relic_instrumentation
      @base.configure :production do
        require 'newrelic_rpm'
        require 'newrelic_instrumentation'
      end

      @base.configure :development do
        require 'new_relic/control'
        NewRelic::Control.instance.init_plugin 'developer_mode' => true,
          :env => 'development'

        require 'new_relic/rack/developer_mode'
        use NewRelic::Rack::DeveloperMode

        require 'newrelic_instrumentation'
      end
    end

    def catch_errors_with_hoptoad
      @base.configure :production do
        if ENV['HOPTOAD_API_KEY']
          require 'active_support'
          require 'active_support/core_ext/object/blank'
          require 'hoptoad_notifier'

          HoptoadNotifier.configure do |config|
            config.api_key = ENV['HOPTOAD_API_KEY']
          end

          use HoptoadNotifier::Rack
          enable :raise_errors
        end
      end
    end

    def handle_requests_using_fiber_pool
      return if @base.test?

      @base.configure do
        require 'rack/fiber_pool'
        use Rack::FiberPool
      end
    end

    def register_response_and_view_helpers
      @base.register Sinatra::RespondWith
      @base.register JammitHelper
      @base.helpers { include Rack::Utils }
    end

    def serve_public_assets
      @base.set :public, 'public'
    end

    def vary_all_responses_on_accept_header
      @base.before { headers['Vary'] = 'Accept' }
    end
  end

end
