require 'drop'

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

  describe '#item_type' do
    it 'delegates to #data' do
      item_type = 'bookmark'
      drop      = Drop.new :item_type => item_type

      drop.item_type.should == item_type
    end
  end

  describe '#content_url' do
    it 'delegates to #data' do
      content_url = 'http://cl.ly/hhgttg/chapter1.txt'
      drop        = Drop.new :content_url => content_url

      drop.content_url.should == content_url
    end
  end

  describe '#download_url' do
    it 'delegates to #data' do
      download_url = 'http://cl.ly/hhgttg/chapter1.txt'
      drop        = Drop.new :download_url => download_url

      drop.download_url.should == download_url
    end
  end

  describe '#name' do
    it 'delegates to #data' do
      name = 'Chapter 1'
      drop = Drop.new :name => name

      drop.name.should == name
    end
  end

  describe '#content' do
    let(:content_url) { 'http://cl.ly/hhgttg/chapter1.txt' }
    let(:content)     { 'Chapter 1' }

    before do
      Content.stub!(:new).
        with(content_url).
        and_return(stub(:content => content))
    end

    it 'delegates content' do
      drop = Drop.new :content_url => content_url

      drop.content.should == content
    end
  end

  describe '#bookmark?' do
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
    %w( png jpg gif ).each do |ext|
      it "is true when a #{ ext.upcase } file" do
        drop = Drop.new :content_url => "http://cl.ly/hhgttg/cover.#{ ext }"

        drop.should be_image
      end
    end

    it 'is true when an image with an upper case extension' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.PNG'

      drop.should be_image
    end

    it 'is false when a TIFF file' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.tiff'

      drop.should_not be_image
    end
  end

  describe '#plain_text?' do
    it 'is true when a TXT file' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/chapter1.txt'

      drop.should be_plain_text
    end

    it 'is false when a TIFF file' do
      drop = Drop.new :content_url => 'http://cl.ly/hhgttg/cover.tiff'

      drop.should_not be_plain_text
    end
  end

  describe '#text?' do
    it 'is true when a plain text file' do
      content_url = 'http://cl.ly/hhgttg/chapter1.txt'

      Drop.new(:content_url => content_url).should be_text
    end

    it 'is true when a markdown file' do
      content_url = 'http://cl.ly/hhgttg/chapter1.md'
      response    = stub :code? => false, :markdown? => true
      Content.stub!(:new).with(content_url).and_return(response)

      Drop.new(:content_url => content_url).should be_text
    end

    it 'is true when a code file' do
      content_url = 'http://cl.ly/hhgttg/hello.rb'
      response    = stub :code? => true, :markdown? => false
      Content.stub!(:new).with(content_url).and_return(response)

      Drop.new(:content_url => content_url).should be_text
    end

    it 'is false when no content url' do
      drop = Drop.new :content_url => nil

      drop.should_not be_text
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
