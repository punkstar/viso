require 'rubypython'
require 'pygments.rb'

class Content
  module Code
    include Pygments

    # Heroku's cedar stack raises an "invalid ELF header" exception using the
    # latest version of python (2.7) on the system. python2.6 seems to work fine.
    RubyPython.configure :python_exe => 'python2.6'

    def content
      return super unless code?

      highlight raw, :lexer => lexer_name
    end

  # private

    def code?
      lexer_name && !%w( text postscript minid ).include?(lexer_name)
    end

    def lexer_name
      @lexer_name ||= lexer_name_for :filename => @content_url
    rescue RubyPython::PythonError
      false
    end

  end
end
