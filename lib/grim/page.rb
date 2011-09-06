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
    # path - String of the path to save to
    #
    # For example:
    #
    #   pdf[1].save(/path/to/save/image.png)
    #   # => true
    #
    # Returns a File.
    #
    def save(path)
      `convert -resize #{Grim::WIDTH} -antialias -render -quality #{Grim::QUALITY} -colorspace RGB -interlace none -density #{Grim::DENSITY} #{@pdf.path}[#{@index}] #{path}`
      File.exists?(path)
    end

    # Extracts the text from the selected page.
    #
    # For example:
    #
    #   pdf[1].text
    #   # => "This is text from slide 2.\n\nAnd even more text from slide 2."
    #
    # Returns a String.
    #
    def text
      `pdftotext -enc UTF-8 -f #{@page} -l #{@page} #{@pdf.path} -`
    end
  end
end