require 'redcarpet'

class Content
  module Markdown
    def content
      return super unless markdown?
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(raw)
    end

    def markdown?
      %w( .md
          .mdown
          .markdown ).include? extension
    end

  private

    def extension
      File.extname(@content_url).downcase
    end
  end
end
