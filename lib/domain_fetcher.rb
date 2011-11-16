require 'domain'

class DomainFetcher

  def self.base_uri
    @base_uri
  end
  @base_uri = ENV.fetch 'CLOUDAPP_DOMAIN', 'api.cld.me'

  def self.fetch(domain)
    Domain.new Yajl::Parser.parse fetch_domain_content(domain),
                                  :symbolize_keys => true
  end

private

  def self.fetch_domain_content(domain)
    EM::HttpRequest.new("http://#{ base_uri }/domains/#{ domain }").
                    get(:head => { 'Accept'=> 'application/json' }).
                    response
  end

end
