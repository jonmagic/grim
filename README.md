```
                    ,____
                    |---.\
            ___     |    `
           / .-\  ./=)
          |  |"|_/\/|
          ;  |-;| /_|
         / \_| |/ \ |
        /      \/\( |
        |   /  |` ) |
        /   \ _/    |
       /--._/  \    |
       `/|)    |    /
         /     |   |
       .'      |   |
      /         \  |
     (_.-.__.__./  /
```

# Grim

Grim is a simple gem for extracting (reaping) a page from a pdf and converting it to an image as well as extract the text from the page as a string. It basically gives you an easy to use api to ghostscript, imagemagick, and pdftotext specific to this use case.

## Prerequisites

You will need ghostscript, imagemagick, and xpdf installed. On the Mac (OSX) I highly recommend using [Homebrew](http://mxcl.github.com/homebrew/) to get them installed.

```bash
$ brew install ghostscript imagemagick xpdf
```

## Installation

```bash
$ gem install grim
```

## Usage

```ruby
pdf   = Grim.reap("/path/to/pdf")         # returns Grim::Pdf instance for pdf
count = pdf.count                         # returns the number of pages in the pdf
png   = pdf[3].save('/path/to/image.png') # will return true if page was saved or false if not
text  = pdf[3].text                       # returns text as a String

pdf.each do |page|
  puts page.text
end
```

We also support using other processors (the default is whatever version of Imagemagick/Ghostscript is in your path).

```ruby
# specifying one processor with specific ImageMagick and GhostScript paths
Grim.processor =  Grim::ImageMagickProcessor.new({:imagemagick_path => "/path/to/convert", :ghostscript_path => "/path/to/gs"})

# multiple processors with fallback if first fails, useful if you need multiple versions of convert/gs
Grim.processor = Grim::MultiProcessor.new([
  Grim::ImageMagickProcessor.new({:imagemagick_path => "/path/to/6.7/convert", :ghostscript_path => "/path/to/9.04/gs"}),
  Grim::ImageMagickProcessor.new({:imagemagick_path => "/path/to/6.6/convert", :ghostscript_path => "/path/to/9.02/gs"})
])

pdf = Grim.reap('/path/to/pdf')
```

You can even specify a Windows executable :zap:

```ruby
# specifying another ghostscript executable, win64 in this example
# the ghostscript/bin folder still has to be in the PATH for this to work
Grim.processor =  Grim::ImageMagickProcessor.new({:ghostscript_path => "gswin64c.exe"})

pdf = Grim.reap('/path/to/pdf')
```

`Grim::ImageMagickProcessor#save` supports several options as well:

```ruby
pdf = Grim.reap("/path/to/pdf")
pdf[0].save('/path/to/image.png', {
  :width => 600,         # defaults to 1024
  :density => 72,        # defaults to 300
  :quality => 60,        # defaults to 90
  :colorspace => "CMYK", # defaults to "RGB"
  :alpha => "Activate"   # not used when not set
})
```

Grim has limited logging abilities. The default logger is `Grim::NullLogger` but you can also set your own logger.

```ruby
require "logger"
Grim.logger = Logger.new($stdout).tap { |logger| logger.progname = 'Grim' }
Grim.processor = Grim::ImageMagickProcessor.new({:ghostscript_path => "/path/to/bin/gs"})
pdf = Grim.reap("/path/to/pdf")
pdf[3].save('/path/to/image.png')
# D, [2016-06-09T22:43:07.046532 #69344] DEBUG -- grim: Running imagemagick command
# D, [2016-06-09T22:43:07.046626 #69344] DEBUG -- grim: PATH=/path/to/bin:/usr/local/bin:/usr/bin
# D, [2016-06-09T22:43:07.046787 #69344] DEBUG -- grim: convert -resize 1024 -antialias -render -quality 90 -colorspace RGB -interlace none -density 300 /path/to/pdf /path/to/image.png
```

## Reference

* [jonmagic.com: Grim](http://theprogrammingbutler.com/blog/archives/2011/09/06/grim/)
* [jonmagic.com: Grim MultiProcessor](http://theprogrammingbutler.com/blog/archives/2011/10/06/grim-multiprocessor-to-the-rescue/)

## Contributors

* [@jonmagic](https://github.com/jonmagic)
* [@jnunemaker](https://github.com/jnunemaker)
* [@bryckbost](https://github.com/bryckbost)
* [@bkeepers](https://github.com/bkeepers)
* [@BobaFaux](https://github.com/BobaFaux)
* [@Rubikan](https://github.com/Rubikan)
* [@victormier](https://github.com/victormier)
* [@philgooch](https://github.com/philgooch)
* [@adamcrown](https://github.com/adamcrown)
* [@fujimura](https://github.com/fujimura)
* [@JamesPaden](https://github.com/JamesPaden)
* [@fgiannattasio](https://github.com/fgiannattasio)

## License

See [LICENSE](LICENSE) for details.
