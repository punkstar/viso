require 'domain'

describe Domain do

  describe '#home_page' do
    it 'delegates to #data' do
      domain = Domain.new :home_page => 'http://hhgproject.org'

      domain.home_page.should == 'http://hhgproject.org'
    end
  end

end
