# encoding: UTF-8
require 'benchmark'
require 'rubygems'
require 'bundler/setup'
require 'rbconfig'

require 'grim'

module FileHelpers
  def dimensions_for_path(path)
    width, height = `identify -format '%wx%h' #{path}`.strip.split('x').map(&:to_f)
  end

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

RSpec.configure do |config|
  config.include(FileHelpers)
  config.filter_run_excluding :windows => true if RbConfig::CONFIG['host_os'].match(/mswin|mingw|cygwin/) == nil
end