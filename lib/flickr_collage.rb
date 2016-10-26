require 'flickr_collage/version'
require 'flickr_collage/errors'
require 'flickr_collage/dictionary'
require 'flickr_collage/file_loader'

require 'rmagick'
require 'flickraw'

require 'flickr_collage/initializer'

class FlickrCollage
  attr_accessor :keywords, :random_keywords, :unsuccessful_keywords, :image_list, :collage, :dir, :filename

  def initialize(keywords = [], filename: 'collage.jpg', dir: '.', no_of_images: nil, rows: nil)
    @filename = filename
    @dir = dir
    @no_of_images = no_of_images || (keywords.empty? ? 10 : keywords.length)
    assign_and_extend_keywords(keywords)

    @image_list, @unsuccessful_keywords = FileLoader.image_list(@keywords)

    create_collage(rows: rows || Math.sqrt(@no_of_images).floor)
  end

  def save_image
    @collage.write(File.join(dir, filename))
  rescue
    raise Errors::DirNotFound unless File.directory?(dir.to_s)
    raise Error::FileCannotBeSaved
  end

  private

  def assign_and_extend_keywords(keywords)
    @random_keywords = []
    (@no_of_images - keywords.length).times { @random_keywords << Dictionary.words.sample }
    @keywords = keywords + @random_keywords
  end

  def create_collage(rows: 3, width: 1200)
    @image_list.scene = 0
    collage_list = Magick::ImageList.new

    height = 0
    rows.times do |i|
      row = create_image_row(no_of_images: images_per_row(rows, i))
      collage_list << row.scale(width.to_f / row.columns)
      collage_list.page = Magick::Rectangle.new(0, 0, 0, height)
      height += collage_list.rows
    end

    @collage = collage_list.mosaic
  end

  def create_image_row(no_of_images:, height: 300)
    row = Magick::ImageList.new

    width = 0
    no_of_images.times do
      row << @image_list.scale(height.to_f / @image_list.rows)
      row.page = Magick::Rectangle.new(0, 0, width, 0)
      width += row.columns
      increment_image_list_scene
    end

    row.mosaic
  end

  def increment_image_list_scene
    @image_list.scene += 1
  rescue
    @image_list.scene = 0
  end

  def images_per_row(rows, i)
    @no_of_images / rows + (i.positive? && i <= @no_of_images % rows ? 1 : 0)
  end
end
