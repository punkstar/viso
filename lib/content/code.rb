require 'em-synchrony'
require 'metriks'
require 'pygments.rb'

class Content
  module Code
    # Used by Markdown fenced code blocks. It's already run inside a Defer block
    # so no need to defer here.
    def self.highlight(code, lexer_alias)
      Metriks.timer('pygments').time {
        lexer = Pygments::Lexer.find lexer_alias
        lexer ? lexer.highlight(code) : Pygments.highlight(code)
      }
    end

    def content
      return super unless code?
      return large_content if code_too_large?

      Metriks.timer('pygments').time {
        EM::Synchrony.defer { lexer.highlight raw }
      }
    end

    def code?
      lexer && (lexer.aliases & %w( text postscript minid )).empty?
    end

    def lexer
      Pygments::Lexer.find_by_extname extension
    end

    def code_too_large?
      raw.size >= 50_000
    end

    def large_content
      %{<div class="highlight"><pre><code>#{ escaped_raw }</code></pre></div>}
    end

    def extension
      @url and File.extname(@url).downcase
    end
  end
end
