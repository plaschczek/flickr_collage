require 'spec_helper'

RSpec.describe FlickrCollage::Dictionary do
  context '.path' do
    it 'returns /usr/share/dict/words by default' do
      expect(FlickrCollage::Dictionary.path).to eq('/usr/share/dict/words')
    end
  end

  context '.words' do
    it 'is an Array' do
      expect(FlickrCollage::Dictionary.words).to be_an(Array) if RUBY_PLATFORM =~ /linux/
      expect(FlickrCollage::Dictionary.words(dic: ['appel','cherry'])).to be_an(Array)
    end

    it 'raises an DictionaryNotFound Error unless dict is readable' do
      FlickrCollage::Dictionary.path = nil
      expect { FlickrCollage::Dictionary.words }.to raise_error(FlickrCollage::Errors::DictionaryNotFound)
    end
  end
end
