# Viso
# ------
#
# **Viso** is the magic that powers [CloudApp][] by displaying shared Drops. At
# its core, **Viso** is a simple [Sinatra][] app that retrieves a **Drop's**
# details using the [CloudApp API][]. Images are displayed front and center,
# bookmarks are redirected to their destination, markdown is processed by
# [RedCarpet][], code files are highlighted by [Pygments], and, when all else
# fails, a download button is provided. **Viso** uses [eventmachine][] and
# [rack-fiber_pool][] to serve requests while expensive network I/O is performed
# asynchronously.
#
# [cloudapp]:        http://getcloudapp.com
# [sinatra]:         https://github.com/sinatra/sinatra
# [cloudapp api]:    http://developer.getcloudapp.com
# [redcarpet]:       https://github.com/tanoku/redcarpet
# [pygments]:        http://pygments.org
# [eventmachine]:    https://github.com/eventmachine/eventmachine
# [rack-fiber_pool]: https://github.com/mperham/rack-fiber_pool
require 'eventmachine'
require 'sinatra/base'
require 'yajl'

require 'configuration'
require 'drop'
require 'drop_fetcher'
require 'domain'
require 'domain_fetcher'

class Viso < Sinatra::Base

  register Configuration

  # The home page. Custom domain users have the option to set a home page so
  # ping the API to get the home page for the current domain. Response is cached
  # for one hour.
  get '/' do
    cache_control :public, :max_age => 3600
    redirect DomainFetcher.fetch(env['HTTP_HOST']).home_page
  end

  # The main responder for a **Drop**. Responds to both JSON and HTML and
  # response is cached for 15 minutes.
  get %r{^
         /([^/?#]+)  # Item slug
         (?:
           /  |      # Ignore trailing /
           /o        # Show original image size
         )?
         $}x do |slug|
    fetch_and_render_drop slug
  end

  # The content for a **Drop**. Redirect to the identical path on the API domain
  # where the view counter is incremented and the visitor is redirected to the
  # actual URL of file. Response is cached for 15 minutes.
  get %r{^
         /([^/?#]+)  # Item slug
         /(.+)       # Filename
         $}x do |slug, filename|
    cache_control :public, :max_age => 900
    redirect_to_api
  end

  # Don't need to return anything special for a 404.
  not_found do
    not_found '<h1>Not Found</h1>'
  end


protected

  # Fetch and return a **Drop** with the given `slug`. Handle
  # `DropFetcher::NotFound` errors and render the not found response.
  def fetch_drop(slug)
    DropFetcher.fetch slug
  rescue DropFetcher::NotFound
    not_found
  end

  def fetch_and_render_drop(slug)
    @drop = fetch_drop slug
    cache_control :public, :max_age => 900

    respond_to do |format|

      # Redirect to the bookmark's link, render the image view for an image, or
      # render the generic download view for everything else.
      format.html do
        if @drop.bookmark?
          redirect_to_api
        else
          erb drop_template, :locals => { :body_id => body_id }
        end
      end

      # Handle a JSON request for a **Drop**. Return the same data received from
      # the CloudApp API.
      format.json do
        Yajl::Encoder.encode @drop.data
      end
    end
  rescue => e
    env['async.callback'].call [ 500, {}, 'Internal Server Error' ]
    HoptoadNotifier.notify_or_ignore e if defined? HoptoadNotifier
  end

  # Redirect the current request to the same path on the API domain.
  def redirect_to_api
    redirect "http://#{ DropFetcher.base_uri }#{ request.path }"
  end

  def drop_template
    if @drop.image?
      :image
    elsif @drop.text?
      :text
    else
      :other
    end
  end

  def body_id
    if @drop.image?
      'image'
    elsif @drop.text?
      'text'
    else
      'other'
    end
  end

end
