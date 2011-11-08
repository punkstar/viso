require 'content'
require 'forwardable'

class Drop
  extend Forwardable

  attr_accessor :data

  def initialize(data)
    @data = data
    @content = Content.new content_url
  end

  def_delegator :@content, :content

  def subscribed?
    data[:subscribed]
  end

  def bookmark?
    data[:item_type] == 'bookmark'
  end

  def image?
    %w( bmp
        gif
        ico
        jp2
        jpe
        jpeg
        jpf
        jpg
        jpg2
        jpgm
        png ).include? extension
  end

  def markdown?
    %w( md
        mdown
        markdown ).include? extension
  end

  def plain_text?
    extension == 'txt'
  end

private

  def content_url
    data[:content_url]
  end

  def extension
    File.extname(content_url)[1..-1].to_s.downcase if content_url
  end

end
