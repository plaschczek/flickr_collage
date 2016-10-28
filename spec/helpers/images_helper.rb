module ImagesHelper
  def random_image
    Magick::Image.new(400 + rand(200), 400 + rand(200)) do
      self.background_color = Kernel.format('#%06x', rand * 0xffffff)
    end
  end

  def random_image_list(no_of_images)
    image_list = Magick::ImageList.new
    no_of_images.times { image_list.push(random_image) }
    image_list
  end
end
