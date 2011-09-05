require "slite/version"

# Slite is a module for reading a pdf and extracting the number of pages,
# extracting a page and outputting as a png or jpeg, as well as exctracting
# the text from a page in a pdf and returning it as a string.
#
module Slite
  # Default resize output width, any positive integer
  WIDTH = 1024

  # Default image quality, 1 to 100
  QUALITY = 90

  # Default density, any positive integer
  DENSITY = 300

  # Default exception class for Slite.
  class Exception < ::StandardError
  end

  # Exception that is raised if pdf is not found.
  class PdfNotFound < Slite::Exception
  end

  # Pdf class with instance methods for getting number of pages in a pdf,
  # extracting a page, and extracting the text from a page.
  #
  # For example:
  #
  #    instance    = Slite::Pdf.new("/path/to/pdf")
  #    page_count  = instance.page_count
  #    png         = instance.page(1).to_png("/path/to/save/png")
  #    jpeg        = instance.page(2).to_jpeg("/path/to/save/jpeg")
  #    text        = instance.page(3).text
  #
  class Pdf
    # be able to store what page instance should focus on
    attr_accessor :page_number

    # initialize is called when a new instance is created and accepts path.
    def initialize(path)
      raise Slite::PdfNotFound unless File.exists?(path)
      @page_number = 1
      @path = path
    end

    # page_count is an instance method on Slite::Pdf. It uses the memoized
    # path and shells out to ghostscript to read the pdf with the pdf_info.ps
    # script as a filter, returning the number of pages in the pdf as an integer.
    #
    # For example:
    #
    #    instance.page_count
    # => 4
    #
    # Returns an integer.
    def page_count
      @page_count ||= begin
        `gs -dNODISPLAY -q -sFile=#{@path} ./lib/pdf_info.ps`.to_i
      end
    end

    # page just sets the page attribute on the instance.
    #
    # For example:
    #
    #    instance.page(1)
    # => instance
    #
    # Returns self.
    def page(number)
      @page_number = number
      self
    end

    # Returns page_number minus 1
    def index
      @page_number - 1
    end

    # to_image extracts the selected page and turns it into an image.
    # Tested on png and jpeg.
    #
    # For example:
    #
    #    instance.page(2).to_image(/path/to/save/image)
    # => File
    #
    # Returns an instance of File
    def to_image(path)
      `convert -resize #{Slite::WIDTH} -antialias -render -quality #{Slite::QUALITY} -colorspace RGB -interlace none -density #{Slite::DENSITY} #{@path}[#{index}] #{path}`
      file = File.open(path)
      file.rewind
      file
    end
  end
end