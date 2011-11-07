require File.expand_path('../../lib/drop', __FILE__)

describe Drop do

  describe '#subscribed?' do
    it 'is true when subscribed' do
      drop = Drop.new :subscribed => true

      drop.should be_subscribed
    end

    it 'is false when not subscribed' do
      drop = Drop.new :subscribed => false

      drop.should_not be_subscribed
    end
  end

  describe '#bookmark' do
    it 'is true when a bookmark' do
      drop = Drop.new :item_type => 'bookmark'

      drop.should be_bookmark
    end

    it 'is false when an image' do
      drop = Drop.new :item_type => 'image'

      drop.should_not be_bookmark
    end
  end

  describe '#image?' do
    it 'is true when a PNG' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.png'

      drop.should be_image
    end

    it 'is true when a PNG with a capital extension' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.PNG'

      drop.should be_image
    end

    it 'is true when a JPG' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.jpg'

      drop.should be_image
    end

    it 'is false when a TIFF' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.tiff'

      drop.should_not be_image
    end
  end

  describe '#markdown?' do
    it 'is true when a MD' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/chapter1.md'

      drop.should be_markdown
    end

    it 'is false when a PNG' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.png'

      drop.should_not be_markdown
    end
  end

  describe '#data' do
    it 'is a hash of itself' do
      data = { :name => 'The Guide' }
      drop = Drop.new data

      drop.data.should == data
    end
  end

end
