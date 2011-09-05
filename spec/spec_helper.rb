require 'rubygems'
require 'bundler/setup'

require 'slite'

RSpec.configure do |config|
  def fixture_path(name)
    path = File.expand_path("./spec/fixtures/")
    File.join(path, name)
  end
end