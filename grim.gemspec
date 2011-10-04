# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "grim/version"

Gem::Specification.new do |s|
  s.name        = "grim"
  s.version     = Grim::VERSION
  s.authors     = ["Jonathan Hoyt"]
  s.email       = ["jonmagic@gmail.com"]
  s.homepage    = "http://github.com/jonmagic/grim"
  s.summary     = %q{Extract slides and text from a PDF.}
  s.description = %q{Grim is a simple gem for extracting a page from a pdf and converting it to an image as well as extract the text from the page as a string. It basically gives you an easy to use api to ghostscript, imagemagick, and pdftotext specific to this use case.}

  s.rubyforge_project = "grim"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
