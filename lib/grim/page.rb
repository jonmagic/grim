# encoding: UTF-8
module Grim
  class Page

    attr_reader :number

    # Sets up some instance variables on new instance.
    #
    # pdf - the pdf this page belongs to
    # index - the index of the page in the array of pages
    #
    def initialize(pdf, index)
      @pdf    = pdf
      @index  = index
      @number   = index + 1
    end

    # Extracts the selected page and turns it into an image.
    # Tested on png and jpeg.
    #
    # path - String of the path to save to
    # options - Hash of options to customize the saving of the image
    #           (ie: width, density, and quality)
    #
    # For example:
    #
    #   pdf[1].save(/path/to/save/image.png)
    #   # => true
    #
    # Returns a File.
    #
    def save(path, options={})
      raise PathMissing if path.nil? || path !~ /\S/

      Grim.processor.save(@pdf, @index, path, options)
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
      `#{["pdftotext", "-enc", "UTF-8", "-f", @number, "-l", @number, Shellwords.escape(@pdf.path), "-"].join(' ')}`
    end
  end
end