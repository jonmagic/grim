# Grim is a class with instance methods for getting number of pages in a pdf,
# extracting a page as an image, and extracting the text from a page.
#
# For example:
#
#    instance    = Grim.new("/path/to/pdf")
#    page_count  = instance.page_count
#    png         = instance.page(1).to_image("/path/to/save/image.png")
#    jpeg        = instance.page(2).to_image("/path/to/save/image.jpeg")
#    text        = instance.page(3).text
#
class Grim
  # VERSION
  VERSION = "0.1.0"

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

  # be able to store what page instance should focus on
  attr_accessor :page_number

  # initialize is called when a new instance is created and accepts path.
  #
  # path - A String or Path to the pdf
  def initialize(path)
    raise Grim::PdfNotFound unless File.exists?(path)
    @page_number = 1
    @path = path
  end

  # Shells out to ghostscript to read the pdf with the pdf_info.ps script
  # as a filter, returning the number of pages in the pdf as an integer.
  #
  # For example:
  #
  #   instance.page_count
  #   # => 4
  #
  # Returns an Integer.
  def page_count
    @page_count ||= begin
      `gs -dNODISPLAY -q -sFile=#{@path} ./lib/pdf_info.ps`.to_i
    end
  end

  # Sets the page attribute on the instance.
  #
  # number - An Integer of the page number to extract
  #
  # For example:
  #
  #   instance.page(1)
  #   # => self
  #
  # Returns self.
  def page(number)
    @page_number = number
    self
  end

  # Page number minus 1
  #
  # For example:
  #
  #   instance.page(2)
  #   instance.index
  #   # => 1
  #
  # Returns an Integer.
  def index
    @page_number - 1
  end

  # Extracts the selected page and turns it into an image.
  # Tested on png and jpeg.
  #
  # path - A String or Path to save image to
  #
  # For example:
  #
  #   instance.page(2).to_image(/path/to/save/image)
  #   # => File
  #
  # Returns a File.
  def to_image(path)
    `convert -resize #{Grim::WIDTH} -antialias -render -quality #{Grim::QUALITY} -colorspace RGB -interlace none -density #{Grim::DENSITY} #{@path}[#{index}] #{path}`
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
    `pdftotext -enc UTF-8 -f #{@page_number} -l #{@page_number} #{@path} -`
  end
end