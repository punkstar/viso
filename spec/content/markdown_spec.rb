require 'support/vcr'
require 'content/markdown'

describe Content::Markdown do
  before do
    module FakeSuper
      def content
        'super content'
      end
    end

    class FakeContent
      include FakeSuper
      include Content::Markdown

      def initialize(content_url)
        @content_url = content_url
      end

      def raw
        '# Chapter 1'
      end
    end
  end

  after do
    Object.send :remove_const, :FakeContent
    Object.send :remove_const, :FakeSuper
  end

  describe '#content' do
    it 'generates markdown' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/chapter1.md'
      markdown = '<h1>Chapter 1</h1>'

      drop.content.strip.should == markdown
    end

    it 'calls #super for non-markdown files' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/chapter1.txt'

      drop.content.should == 'super content'
    end
  end

  describe '#markdown?' do
    %w( md mdown markdown ).each do |ext|
      it "is true when a #{ ext.upcase } file" do
        drop = FakeContent.new "http://cl.ly/hhgttg/cover.#{ ext }"

        drop.should be_markdown
      end
    end

    it 'is true when a markdown file with an upper case extension' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/cover.MD'

      drop.should be_markdown
    end

    it 'is false when an image' do
      drop = FakeContent.new 'http://cl.ly/hhgttg/cover.png'

      drop.should_not be_markdown
    end
  end

end
