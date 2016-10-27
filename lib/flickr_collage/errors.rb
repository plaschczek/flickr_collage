class FlickrCollage
  class Errors
    class DictionaryNotFound < StandardError; end
    class DirNotFound < StandardError; end
    class FileCannotBeSaved < StandardError; end
    class FileExist < StandardError; end
    class NoFlickRawURLMethod < StandardError; end
    class NoImageFound < StandardError; end
  end
end
