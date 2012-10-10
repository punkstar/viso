require 'metriks'
require 'pygments.rb'

class Content
  module Code
    def self.highlight(code, lexer)
      Metriks.timer('pygments').time {
        lexer.highlight code
      }
    end

    def content
      return super unless code?
      return large_content if code_too_large?

      Code.highlight raw, lexer
    end

    def code?
      lexer && (lexer.aliases & %w( text postscript minid )).empty?
    end

    def lexer
      timer = Metriks.timer('pygments.lexer').time do
        Pygments::Lexer.find_by_extname extension
      end
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
