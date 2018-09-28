class FlickrCollage
  class Dictionary
    @path = '/usr/share/dict/words'

    class << self
      attr_reader :path
    end

    def self.path=(value)
      @words = nil
      @path = value
    end

    def self.words(dic: nil)
      @words = dic if dic # for overwriting system dictionary
      @words ||= File.open(@path.to_s).read.to_s.split("\n")
    rescue
      raise Errors::DictionaryNotFound
    end
  end
end
