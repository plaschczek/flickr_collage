# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickr_collage/version'

Gem::Specification.new do |spec|
  spec.name          = 'flickr_collage'
  spec.version       = FlickrCollage::VERSION
  spec.authors       = ['Ingo Plaschczek']
  spec.email         = ['github@plaschczek.de']

  spec.summary       = %q{Makes a collage of Flickr images by keywords}
  spec.description   = %q{Flickr Collage queries the Flickr API for the top-rated image by search keywords and assembles a collage grid from this images to a new file.}
  spec.homepage      = 'https://github.com/plaschczek/flickr_collage'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = ['flickr_collage']
  spec.require_paths = ['lib']

  spec.add_dependency 'flickraw'
  spec.add_dependency 'rmagick'
  spec.add_dependency 'highline'
  spec.add_dependency 'cri', '2.15.11'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
