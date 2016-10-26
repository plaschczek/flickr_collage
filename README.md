# Flickr Collage

Flickr Collage queries the Flickr API for the top-rated image by search keywords and assembles a collage grid from this images to a new file.


## Installation

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

For more details take a look at (https://github.com/hanklords/flickraw#usage)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
