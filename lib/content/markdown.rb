require 'em-synchrony'
require 'metriks'
require 'redcarpet'

class Content
  module Markdown
    def content
      return super unless markdown?
      Metriks.timer('markdown').time {
        # Both EM::Synchrony.defer and #raw call Fiber.yield so they can't be
        # nested. Download content outside the .defer block.
        downloaded = raw

        EM::Synchrony.defer {
          Redcarpet::Markdown.
            new(PygmentizedHTML, fenced_code_blocks: true).
            render(downloaded)
        }
      }
    end

    def markdown?
      %w( .md
          .mdown
          .markdown ).include? extension
    end

  private

    def extension
      @url and File.extname(@url).downcase
    end
  end

  # TODO: This is just a spike.
  class PygmentizedHTML < Redcarpet::Render::HTML
    def block_code(code, language)
      Content::Code.highlight code, language
    end
  end
end
