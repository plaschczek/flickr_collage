require 'spec_helper'

RSpec.describe FlickrCollage do
  def random_image
    Magick::Image.new(200 + rand(200), 200 + rand(200)) do
      self.background_color = "#%06x" % (rand * 0xffffff)
    end
  end

  def random_image_list(no_of_images)
    image_list = Magick::ImageList.new
    no_of_images.times { image_list.push(random_image) }
    image_list
  end

  it 'has a version number' do
    expect(FlickrCollage::VERSION).not_to be nil
  end

  let(:keywords) { [] }
  let(:no_of_images) { nil }
  let(:keywords_count) { no_of_images || (keywords.length > 0 ? keywords.length : 10) }

  subject(:flickr_collage) { FlickrCollage.new(keywords, no_of_images: no_of_images) }

  before do
    allow(FlickrCollage::FileLoader).to receive(:image_list).and_return(random_image_list(keywords_count))
    allow(FlickrCollage::Dictionary).to receive(:words).and_return(['color'])
  end

  context '.new' do
    it 'has 10 random keywords by default' do
      expect(flickr_collage.random_keywords.count).to eq(10)
    end

    it 'has 10 images by default' do
      expect(flickr_collage.image_list.count).to eq(10)
    end

    it "has '.' as default directiory" do
      expect(flickr_collage.dir).to eq('.')
    end

    it "has 'collage.jpg' as default filename" do
      expect(flickr_collage.filename).to eq('collage.jpg')
    end

    it 'has false as default squares value' do
      expect(flickr_collage.squares).to eq(false)
    end

    context 'with 3 keywords' do
      let(:keywords) { ['violet', 'green', 'blue'] }

      it 'has 3 images unless no_of_images set' do
        expect(flickr_collage.image_list.count).to eq(3)
      end

      context 'and no_of_images: 5' do
        let(:no_of_images) { 5 }

        it 'has 5 images' do
          expect(flickr_collage.image_list.count).to eq(5)
        end

        it 'has 2 random keywords' do
          expect(flickr_collage.random_keywords.count).to eq(2)
        end
      end
    end
  end

  context '#save' do
    it 'raises FileExist error if filename exists' do
      @flickr_collage = FlickrCollage.new(filename: 'tmp/fruits.jpg')

      expect { @flickr_collage.save }.to raise_exception(FlickrCollage::Errors::FileExist)
    end

    it 'raises DirNotFound error unless dir exists' do
      @flickr_collage = FlickrCollage.new(dir: 'uiaeuiaeuiae')

      expect { @flickr_collage.save }.to raise_exception(FlickrCollage::Errors::DirNotFound)
    end

    it 'raises FileCannotBeSaved error without write permissions' do
      @flickr_collage = FlickrCollage.new(dir: '/')

      expect { @flickr_collage.save }.to raise_exception(FlickrCollage::Errors::FileCannotBeSaved)
    end
  end

  context '#save!' do
    it 'saves rspec_color_collage.jpg at tmp even if file exists' do
      @flickr_collage = FlickrCollage.new(dir: 'tmp', filename: 'rspec_color_collage.jpg')
      @flickr_collage.save!
      expect(@flickr_collage.save!).to be_truthy
    end

    it 'raises DirNotFound error unless dir exists' do
      @flickr_collage = FlickrCollage.new(dir: 'uiaeuiaeuiae')

      expect { @flickr_collage.save! }.to raise_exception(FlickrCollage::Errors::DirNotFound)
    end

    it 'raises FileCannotBeSaved error without write permissions' do
      @flickr_collage = FlickrCollage.new(dir: '/')

      expect { @flickr_collage.save! }.to raise_exception(FlickrCollage::Errors::FileCannotBeSaved)
    end
  end
end
