module Grim
  class ImageMagickProcessor

    # ghostscript prints out a warning, this regex matches it
    WarningRegex = /\*\*\*\*.*\n/

    def initialize(options={})
      @imagemagick_bin_path = options[:imagemagick_bin_path]
      @ghostscript_bin_path = options[:ghostscript_bin_path]
      @original_path        = ENV['PATH']
    end

    def count(path)
      modify_path
      result = SafeShell.execute("gs", "-dNODISPLAY", "-q", "-sFile=#{path}", File.expand_path('../../../lib/pdf_info.ps', __FILE__))
      release_path
      result.gsub(WarningRegex, '').to_i
    end

    def save(pdf, index, path, options)
      modify_path

      width   = options.fetch(:width,   Grim::WIDTH)
      density = options.fetch(:density, Grim::DENSITY)
      quality = options.fetch(:quality, Grim::QUALITY)
      output = SafeShell.execute('convert', "-resize", width, "-antialias", "-render",
        "-quality", quality, "-colorspace", "RGB",
        "-interlace", "none", "-density", density,
        "#{pdf.path}[#{index}]", path)

      release_path

      $? == 0 || raise(UnprocessablePage, output)
    end

    def modify_path
      ENV['PATH'] = "#{@imagemagick_bin_path}:#{ENV['PATH']}" if @imagemagick_bin_path
      ENV['PATH'] = "#{@ghostscript_bin_path}:#{ENV['PATH']}" if @ghostscript_bin_path
    end

    def release_path
      ENV['PATH'] = @original_path
    end
  end
end