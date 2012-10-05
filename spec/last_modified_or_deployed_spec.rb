require 'helper'
require 'last_modified_or_deployed'

describe LastModifiedOrDeployed do
  class App
    module Original
      def last_modified(modified) @modified = modified end
      def last_modified_value()   @modified end
    end

    include Original
    include LastModifiedOrDeployed
  end

  after do ENV.delete 'RAILS_ASSET_ID' end

  context 'when the deployed date is older' do
    let(:modified) { Time.new(2012, 4, 1) }
    let(:app)      { App.new }
    subject { app.last_modified_value }
    before do
      ENV['RAILS_ASSET_ID'] = '0'
      app.last_modified modified
    end

    it { should eq(modified) }
  end

  context 'when the deployed date is older' do
    let(:modified) { Time.new(1900, 4, 1) }
    let(:app)      { App.new }
    subject { app.last_modified_value }
    before do
      ENV['RAILS_ASSET_ID'] = '0'
      app.last_modified modified
    end

    it { should eq(Time.at(0)) }
  end
end
