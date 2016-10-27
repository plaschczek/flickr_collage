# Flickr Collage

**Flickr Collage** queries the Flickr API for the top-rated image by search keywords and assembles a collage grid from this images to a new file.

![](tmp/fruits.jpg)

## Installation

You have to install **ImageMagick**. On Ubuntu for example, you can run:

```
sudo apt-get install libmagickwand-dev
```

For more details take a look at (https://github.com/rmagick/rmagick#prerequisites).

**Installing via Bundler**

Add this line to your application's Gemfile:

```ruby
gem 'flickr_collage', github: 'plaschczek/flickr_collage'
```

And then execute:

```console
bundle
```

## Usage

First you have to initialize FlickRaw.api_key and FlickRaw.shared_secred.<br />
For example export the following env vars:

```console
export FLICKR_API_KEY='... Your API key ...'
export FLICKR_SHARED_SECRET='... Your shared secret ...'
```

Or in your Ruby file:

```ruby
require 'flickr_collage'

FlickRaw.api_key="... Your API key ..."
FlickRaw.shared_secret="... Your shared secret ..."
```

### Examples

To create a collage with 10 random images, instantiate a new FlickrCollage and save the image:

```ruby
FlickrCollage.new.save
```

Full options example (9 images, 4 by keyword, 5 random in 2 rows as squares, saved as 'tmp/fruits_example.jpg'):

```ruby
FlickrCollage.new(
  keywords: ['strawberry', 'kiwi', 'cherry', 'limes'],
  filename: 'fruits_example.jpg',
  dir: 'tmp',
  no_of_images: 9,
  rows: 2,
  squares: true
).save
```

### Command Line Examples

The same full options example as before:

```console
flickr_collage -k strawberry,kiwi,cherry,limes -f fruits_example.jpg -d tmp -n 9 -r 2 -s
```

And the command line help:

```console
flickr_collage -h
```

### Options

```
FlickrCollage.new(keywords:, filename:, dir:, no_of_images:, rows:, squares:)

    keywords: Array with keywords
    filename: collage filename, default 'collage.jpg'
         dir: directory to save the collage, has to exist, default '.'
no_of_images: number of images, default number of keywords and without keywords 10
        rows: number of collage rows, default sqrt(no_of_images).floor
     squares: boolean, if true images squared
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
