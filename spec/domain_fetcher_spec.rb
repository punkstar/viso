require 'support/vcr'
require 'domain_fetcher'

describe DomainFetcher do
  describe '.fetch' do
    it 'returns a domain' do
      EM.synchrony do
        VCR.use_cassette 'domain/success', :erb => { :domain => 'dent.com' } do
          domain = DomainFetcher.fetch 'dent.com'
          EM.stop

          domain.should be_a(Domain)
        end
      end
    end

    it 'symbolizes keys' do
      Domain.should_receive(:new).with(hash_including(:home_page))

      EM.synchrony do
        VCR.use_cassette 'domain/success', :erb => { :domain => 'dent.com' } do
          DomainFetcher.fetch 'dent.com'
          EM.stop
        end
      end
    end
  end
end
