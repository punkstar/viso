require 'support/vcr'
require File.expand_path('../../lib/content', __FILE__)

describe Content do

  describe '#content' do
    subject { Content.new 'http://cl.ly/hhgttg/chapter1.txt' }

    it 'fetches content' do
      EM.synchrony do
        VCR.use_cassette 'text' do
          subject.content.start_with?('Chapter 1').should be_true
        end

        EM.stop
      end
    end
  end

end
