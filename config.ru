require './app'

require 'rack/deflater'
use Rack::Deflater

run App
