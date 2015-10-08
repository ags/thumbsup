$LOAD_PATH << File.expand_path('../../', __FILE__)
$LOAD_PATH << File.expand_path('../../app', __FILE__)

ENV['RACK_ENV'] = 'test'

require 'json'
require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
end

def fixture_path(filename)
  File.expand_path(File.join("fixtures", filename), File.dirname(__FILE__))
end

def read_fixture(filename)
  File.read(fixture_path(filename))
end

def read_fixture_json(filename)
  JSON.parse(read_fixture(filename))
end
