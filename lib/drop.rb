require 'ostruct'

class Drop < OpenStruct

  def subscribed?
    subscribed
  end

  def bookmark?
    item_type == 'bookmark'
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

  def data
    marshal_dump
  end

private

  def extension
    File.extname(content_url)[1..-1].to_s.downcase if content_url
  end

end
