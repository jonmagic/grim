# encoding: UTF-8
require 'safe_shell'

module Grim
  # Default resize output width, any positive integer
  WIDTH = 1024

  # Default image quality, 1 to 100
  QUALITY = 90

  # Default density, any positive integer
  DENSITY = 300

  # Default exception class for Grim.
  class Exception < ::StandardError
  end

  # Exception that is raised if pdf is not found.
  class PdfNotFound < Grim::Exception
  end

  # Exception that is raised if pdf does not have page
  class PageNotFound < Grim::Exception
  end

  # Exception that is raised if an empty path is passed to Grim::Page#save
  class PathMissing < Grim::Exception
  end

  # Exception that is raised if Grim::Page#save can't process the page
  class UnprocessablePage < Grim::Exception
  end

  # Creates and returns a new instance of Grim::Pdf
  #
  # path - a path string or object
  #
  # For example:
  #
  #   pdf = Grim.reap(/path/to/pdf)
  #
  # Returns an instance of Grim::Pdf
  #
  def self.reap(path)
    Grim::Pdf.new(path)
  end
end

require 'grim/pdf'
require 'grim/page'