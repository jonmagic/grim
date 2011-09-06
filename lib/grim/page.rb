module Grim
  class Page
    # Sets up some instance variables on new instance.
    #
    # pdf - the pdf this page belongs to
    # index - the index of the page in the array of pages
    #
    def initialize(pdf, index)
      @pdf    = pdf
      @index  = index
      @page   = index + 1
    end

    # Extracts the selected page and turns it into an image.
    # Tested on png and jpeg.
    #
    # path - A String or Path to save image to
    #
    # For example:
    #
    #   instance.page(2).image(/path/to/save/image)
    #   # => File
    #
    # Returns a File.
    def image(path)
      `convert -resize #{Grim::WIDTH} -antialias -render -quality #{Grim::QUALITY} -colorspace RGB -interlace none -density #{Grim::DENSITY} #{@pdf.path}[#{@index}] #{path}`
      file = File.open(path)
      file.rewind
      file
    end

    # Extracts the text from the selected page.
    #
    # For example:
    #
    #   instance.page(2).text
    #   # => "This is text from slide 2.\n\nAnd even more text from slide 2."
    #
    # Returns a String.
    def text
      `pdftotext -enc UTF-8 -f #{@page} -l #{@page} #{@pdf.path} -`
    end
  end
end