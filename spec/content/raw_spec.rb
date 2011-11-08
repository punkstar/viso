require 'support/vcr'
require 'content/raw'

describe Content::Raw do
  before do
    class FakeContent
      include Content::Raw

      def initialize(content_url)
        @content_url = content_url
      end

      def raw
        'Chapter 1'
      end
    end
  end

  after { Object.send :remove_const, :FakeContent }

  describe '#content' do
    it 'returns raw content' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/chapter1.txt'

      drop.content.should == 'Chapter 1'
    end
  end
end
