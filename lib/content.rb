class Content

  def initialize(content_url)
    @content_url = content_url
  end

  def content
    @content ||= EM::HttpRequest.new(@content_url).get(:redirects => 3).response
  end

end
