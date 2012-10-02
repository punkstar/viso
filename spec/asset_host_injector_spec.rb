require 'helper'
require 'jammit_helper'
require 'ostruct'

describe JammitHelper::AssetHostInjector do
  class App
    include JammitHelper::AssetHostInjector

    def initialize(options = {})
      @ssl = options.fetch :ssl, false
    end

    def request
      OpenStruct.new :ssl? => @ssl
    end

    def self.development?
      false
    end
  end

  before do ENV['CLOUDFRONT_DOMAIN'] = 'fake.cloudfront.net' end
  after  do ENV.delete 'CLOUDFRONT_DOMAIN' end

  subject do
    Jammit.load_configuration 'config/assets.yml'
    App.new
  end

  it 'serves assets on the cloudfront domain' do
    asset_path = subject.asset_path :js, 'app.js'
    assert { asset_path == '//fake.cloudfront.net/app.js' }
  end
end
