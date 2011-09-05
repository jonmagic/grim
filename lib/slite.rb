require "slite/version"

# Slite is a module for reading a pdf and extracting the number of pages,
# extracting a page and outputting as a png or jpeg, as well as exctracting
# the text from a page in a pdf and returning it as a string.
#
module Slite
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
  #   instance    = Slite::Pdf.new("/path/to/pdf")
  #   page_count  = instance.page_count
  #   png         = instance.page(1).to_png
  #   jpeg        = instance.page(2).to_jpeg("/path/to/save/jpeg")
  #   text        = instance.page(3).text
  #
  class Pdf
    # initialize is called when a new instance is created and accepts path.
    def initialize(path)
      raise Slite::PdfNotFound unless File.exists?(path)
      @path = path
    end

    # page_count is an instance method on Slite::Pdf. It uses the memoized
    # path and shells out to ghostscript to read the pdf with the pdf_info.ps
    # script as a filter, returning the number of pages in the pdf as an integer.
    #
    # For example:
    #
    #   instance.page_count
    #   => 4
    #
    def page_count
      puts @path
      @page_count ||= begin
        `gs -dNODISPLAY -q -sFile=#{@path} ./lib/pdf_info.ps`.to_i
      end
    end

  end
end