require 'content/raw'
require 'content/code'
require 'content/markdown'

class Content

  include Raw
  include Code
  include Markdown

  def initialize(content_url)
    @content_url = content_url
  end

  def raw
    @raw ||= EM::HttpRequest.new(@content_url).get(:redirects => 3).response
  end

end
