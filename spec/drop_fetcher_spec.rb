require 'support/vcr'
require 'drop_fetcher'

describe DropFetcher do
  describe '.fetch' do
    it 'returns a drop' do
      EM.synchrony do
        VCR.use_cassette 'bookmark' do
          drop = DropFetcher.fetch 'hhgttg'
          EM.stop

          drop.should be_a(Drop)
        end
      end
    end

    it 'symbolizes keys' do
      Drop.should_receive(:new).with(hash_including(:content_url))

      EM.synchrony do
        VCR.use_cassette 'bookmark' do
          DropFetcher.fetch 'hhgttg'
          EM.stop
        end
      end
    end

    it 'raises a DropNotFound error' do
      EM.synchrony do
        VCR.use_cassette 'nonexistent' do
          lambda { DropFetcher.fetch 'hhgttg' }.
            should raise_error(DropFetcher::NotFound)

          EM.stop
        end
      end
    end
  end
end
