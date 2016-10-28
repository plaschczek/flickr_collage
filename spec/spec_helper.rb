$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'flickr_collage'
require 'helpers/images_helper'

RSpec.configure do |c|
  c.include ImagesHelper
end
