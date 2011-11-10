require 'support/vcr'
require 'content/code'

describe Content::Code do
  before do
    module FakeSuper
      def content
        'super content'
      end
    end

    class FakeContent
      include FakeSuper
      include Content::Code

      def initialize(content_url)
        @content_url = content_url
      end

      def raw
        'puts "Hello world!"'
      end
    end
  end

  after do
    Object.send :remove_const, :FakeContent
    Object.send :remove_const, :FakeSuper
  end


  describe '#content' do
    it 'syntax highlights content' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/hello.rb'
      code = '<div class="highlight"><pre><span class="nb">puts</span>'

      drop.content.start_with?(code).should == true
    end

    it 'calls #super for non-markdown files' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/chapter1.txt'

      drop.content.should == 'super content'
    end

    it "doesn't highlight large code files" do
      code = %{puts "Hello world!"\n}
      drop = FakeContent.new 'http://cl.ly/hhgttg/hello.rb'
      drop.stub!(:raw => code * 2_500)

      escaped_code = "puts &quot;Hello world!&quot;\n"
      expected = %{<div class="highlight"><pre><code>#{ escaped_code }}

      drop.content[0...expected.size].should == expected
      drop.content.size.should == 75_053
    end

    it 'escapes html in large code files' do
      code = %{<b>HTML</b>}
      drop = FakeContent.new 'http://cl.ly/hhgttg/hello.rb'
      drop.stub!(:raw => code * 5_000)

      escaped_code = '&lt;b&gt;HTML&lt;&#x2F;b&gt;'
      expected = %{<div class="highlight"><pre><code>#{ escaped_code }}

      drop.content[0...expected.size].should == expected
    end
  end

  describe '#code?' do
    it 'is true when a ruby file' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/hello.rb'

      drop.should be_code
    end

    it 'is false when an image' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/cover.png'

      drop.should_not be_code
    end

    %w( ps md txt ).each do |ext|
      it "is false when a #{ ext.upcase } file" do
        drop = FakeContent.new "http://cl.ly/hhgttg/chapter1.#{ ext }"

        drop.should_not be_code
      end
    end
  end

end
