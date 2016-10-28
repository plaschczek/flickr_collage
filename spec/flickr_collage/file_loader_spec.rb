require 'spec_helper'

RSpec.describe FlickrCollage::FileLoader do
  before do
    FlickRaw.api_key = 'api_key'
    FlickRaw.shared_secret = 'shared_secret'

    allow_any_instance_of(FlickRaw::Flickr).to receive(:call).and_return([])
    allow_any_instance_of(FlickRaw::Flickr).to receive_message_chain('photos.search')
      .and_return(['photos.search return'])

    allow(FlickRaw).to receive(:url_b).and_return('url://dummy')
    allow_any_instance_of(FlickrCollage::FileLoader).to receive(:open).and_yield(Tempfile.new)
    allow(Magick::Image).to receive(:from_blob).and_return([random_image])
  end

  it 'contains FLICK_RAW_URL_METHODS constant' do
    expect(FlickrCollage::FileLoader::FLICK_RAW_URL_METHODS)
      .to eq(%w(url url_m url_s url_t url_b url_z url_q url_n url_c url_o))
  end

  context '#load_flickr_files' do
    it 'returns a Magick::ImageList' do
      expect(FlickrCollage::FileLoader.image_list(['test']).first).to be_a(Magick::ImageList)
    end

    it 'raises Errors::NoFlickRawURLMethod for unknown FlickRaw url method' do
      expect { subject.load_flickr_files(['test'], url_method: 'unknown') }
        .to raise_error(FlickrCollage::Errors::NoFlickRawURLMethod)
    end

    context 'without flickr.photos.search response item' do
      before do
        allow(FlickrCollage::Dictionary).to receive(:words).and_return(['word'])
        allow_any_instance_of(FlickRaw::Flickr).to receive_message_chain('photos.search')
          .with(tags: ['test'], sort: 'interestingness-desc', content_type: 1, per_page: 1) { [] }
        allow_any_instance_of(FlickRaw::Flickr).to receive_message_chain('photos.search')
          .with(tags: ['word'], sort: 'interestingness-desc', content_type: 1, per_page: 1) { ['photos.search return'] }
      end

      it 'raises Errors::NoImageFound and retries with a dictionary word' do
        image_list, unsuccessful_keywords = subject.load_flickr_files(['test'])
        expect(image_list).to be_a(Magick::ImageList)
        expect(unsuccessful_keywords).to eq('test' => 'word')
      end
    end
  end

  context '.image_list' do
    it 'calls load_flickr_files on a new instance' do
      allow_any_instance_of(FlickrCollage::FileLoader).to receive(:load_flickr_files)
        .with(['keyword']).and_return('called')
      expect(FlickrCollage::FileLoader.image_list(['keyword'])).to eq('called')
    end
  end
end
