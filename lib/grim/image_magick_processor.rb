module Grim
  class ImageMagickProcessor

    # ghostscript prints out a warning, this regex matches it
    WarningRegex = /\*\*\*\*.*\n/
    DefaultImagemagickPath = 'convert'
    DefaultGhostScriptPath = 'gs'

    def initialize(options={})
      @imagemagick_path = options[:imagemagick_path] || DefaultImagemagickPath
      @ghostscript_path = options[:ghostscript_path] || DefaultGhostScriptPath
      @original_path        = ENV['PATH']
    end

    def count(path)
      command = [@ghostscript_path, "-dNODISPLAY", "-q",
        "-sFile=#{Shellwords.shellescape(path)}",
        File.expand_path('../../../lib/pdf_info.ps', __FILE__)]
      result = `#{command.join(' ')}`
      result.gsub(WarningRegex, '').to_i
    end

    def save(pdf, index, path, options)
      width   = options.fetch(:width,   Grim::WIDTH)
      density = options.fetch(:density, Grim::DENSITY)
      quality = options.fetch(:quality, Grim::QUALITY)
      colorspace = options.fetch(:colorspace, Grim::COLORSPACE)
      command = [@imagemagick_path, "-resize", width.to_s, "-antialias", "-render",
        "-quality", quality.to_s, "-colorspace", colorspace,
        "-interlace", "none", "-density", density.to_s,
        "#{Shellwords.shellescape(pdf.path)}[#{index}]", path]
      command.unshift("PATH=#{File.dirname(@ghostscript_path)}:#{ENV['PATH']}") if @ghostscript_path && @ghostscript_path != DefaultGhostScriptPath

      result = `#{command.join(' ')}`

      $? == 0 || raise(UnprocessablePage, result)
    end
  end
end
