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
    @data[:subscribed]
  end

  def item_type
    @data[:item_type]
  end

  def content_url
    @data[:content_url]
  end

  def download_url
    @data[:download_url]
  end

  def name
    @data[:name]
  end

  def bookmark?
    @data[:item_type] == 'bookmark'
  end

  def image?
    %w( .bmp
        .gif
        .ico
        .jp2
        .jpe
        .jpeg
        .jpf
        .jpg
        .jpg2
        .jpgm
        .png ).include? extension
  end

  def plain_text?
    extension == '.txt'
  end

  def text?
    !content_url.nil? && (plain_text? || @content.markdown? || @content.code?)
  end

  def pending?
    item_type.nil?
  end

private

  def extension
    return unless content_url
    File.extname(content_url).downcase
  end
end
