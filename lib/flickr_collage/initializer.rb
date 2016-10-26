# init FlickRaw
#
# FlickRaw.api_key="... Your API key ..."
# FlickRaw.shared_secret="... Your shared secret ..."

FlickRaw.api_key ||= ENV['FLICKR_API_KEY']
FlickRaw.shared_secret ||= ENV['FLICKR_SHARED_SECRET']
