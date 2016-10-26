require 'open-uri'

class FlickrCollage
  class FileLoader
    FLICK_RAW_URL_METHODS = %w(url url_m url_s url_t url_b url_z url_q url_n url_c url_o).freeze

    attr_accessor :unsuccessful_keywords

    def self.image_list(keywords)
      FileLoader.new.load_flickr_files(keywords)
    end

    def load_flickr_files(keywords, image_list: Magick::ImageList.new, url_method: 'url_b')
      keywords.each { |k| image_list.push(load_flickr_file(k, url_method)) }

      [image_list, @unsuccessful_keywords]
    end

    private

    def load_flickr_file(keyword, url_method)
      open(flickr_file_url(keyword, url_method)) do |uri|
        raise Errors::NoImageFound unless uri.is_a? Tempfile
        return Magick::Image.from_blob(uri.read).first
      end
    rescue Errors::NoImageFound
      (@unsuccessful_keywords ||= {})[keyword] = Dictionary.words.sample
      keyword = @unsuccessful_keywords[keyword]
      retry
    end

    def flickr_file_url(keyword, url_method)
      raise Errors::NoFlickRawURLMethod unless FLICK_RAW_URL_METHODS.include?(url_method)

      FlickRaw.send(url_method, flickr_photo_search(keyword))
    end

    def flickr_photo_search(keyword)
      photo_search = flickr.photos.search(
        tags: [keyword],
        sort: 'interestingness-desc',
        content_type: 1,
        per_page: 1
      )

      raise Errors::NoImageFound unless photo_search.first

      photo_search.first
    end
  end
end
