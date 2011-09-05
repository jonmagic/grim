# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "slite/version"

Gem::Specification.new do |s|
  s.name        = "slite"
  s.version     = Slite::VERSION
  s.authors     = ["Jonathan Hoyt"]
  s.email       = ["jonmagic@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Extract slides and text from a PDF.}
  s.description = %q{Slite is a simple gem for extracting slides (aka pages) and text from a PDF. It basically gives you an easy to use api to ghostscript and imagemagick specific to this use case.}

  s.rubyforge_project = "slite"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
