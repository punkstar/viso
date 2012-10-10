source :gemcutter

gem 'addressable'
gem 'airbrake'
gem 'em-http-request', '~> 1.0'
gem 'em-synchrony',    github: 'igrigorik/em-synchrony'
gem 'jammit-s3', :git => 'https://github.com/kmamykin/jammit-s3.git'
gem 'newrelic_rpm'
gem 'metriks'
gem 'metriks-middleware'
gem 'padrino'
gem 'pygments.rb'
gem 'redcarpet', '~> 2.1'
gem 'simpleidn'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'
gem 'yajl-ruby'

# Bundler gets confused about which version of ruby_parser and wrong to use.
# Help it out by specifying stricter versions.
gem 'ruby_parser', '~> 2.0.6'

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr', '~> 1.11'
  gem 'webmock'

  # See ruby_parser note above.
  gem 'wrong', '~> 0.6.2'
end

group :development do
  gem 'compass'
  gem 'foreman'
  gem 'rocco'
end
