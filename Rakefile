require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => :spec

desc 'Move documentation to the docs project root'
task :move_docs do
  sh 'mv docs/viso.html ../viso-docs/index.html && mv docs/* ../viso-docs'
end

require 'emoji'
load 'tasks/emoji.rake'

task :emoji => :available_emoji do
  # Kill emoji/unicode directory. I'm not clear how it's intended to be used.
  rm_rf "#{Rake.original_dir}/public/images/emoji/unicode"
end

file 'lib/content/emoji.rb' => FileList["#{Emoji.images_path}/emoji/*.png"] do |t|
  puts 'Generating available emoji...'
  File.open t.name, 'w' do |f|
    f.puts <<RUBY
module Emoji
  class << self
    attr_accessor :names
    def include? emoji
      names.include? emoji
    end
  end

  @names = %w( #{Emoji.names.join("\n")} )
end
RUBY
  end
end

desc 'Generate all available emoji'
task :available_emoji => 'lib/content/emoji.rb'
