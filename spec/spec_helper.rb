require 'rubygems'
require 'bundler/setup'

require 'slite'

RSpec.configure do |config|
  def fixture_path(name)
    path = File.expand_path("./spec/fixtures/")
    File.join(path, name)
  end

  def tmp_dir
    path = File.expand_path("./tmp")
    Dir.mkdir(path) unless File.directory?(path)
    path
  end

  def tmp_path(name)
    File.join(tmp_dir, name)
  end
end