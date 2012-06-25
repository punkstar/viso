require 'redcarpet'

class Content
  module Markdown
    def content
      return super unless markdown?
      Redcarpet::Markdown.new(PygmentizedHTML,
                              fenced_code_blocks: true).render(raw)
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

  class PygmentizedHTML < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end
end
