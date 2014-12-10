module Grim
  class ImageMagickProcessor

    # ghostscript prints out a warning, this regex matches it
    WarningRegex = /\*\*\*\*.*\n/

    def initialize(options={})
      @imagemagick_path = options[:imagemagick_path] || 'convert'
      @ghostscript_path = options[:ghostscript_path]
      @ghostscript_exec = options[:ghostscript_executable] || 'gs'
      @original_path        = ENV['PATH']
    end

    def count(path)
      command = ["-dNODISPLAY", "-q",
        "-sFile=#{Shellwords.shellescape(path)}",
        File.expand_path('../../../lib/pdf_info.ps', __FILE__)]
      @ghostscript_path ? command.unshift(@ghostscript_path) : command.unshift(@ghostscript_exec)
      result = `#{command.join(' ')}`
      result.gsub(WarningRegex, '').to_i
    end

    def save(pdf, index, path, options)
      alpha = options.fetch(:alpha, Grim::ALPHA)
      width   = options.fetch(:width,   Grim::WIDTH)
      density = options.fetch(:density, Grim::DENSITY)
      quality = options.fetch(:quality, Grim::QUALITY)
      colorspace = options.fetch(:colorspace, Grim::COLORSPACE)
      command = [@imagemagick_path, "-resize", width.to_s, "-alpha", alpha, "-antialias", "-render",
        "-quality", quality.to_s, "-colorspace", colorspace,
        "-interlace", "none", "-density", density.to_s,
        "#{Shellwords.shellescape(pdf.path)}[#{index}]", path]
      command.unshift("PATH=#{File.dirname(@ghostscript_path)}:#{ENV['PATH']}") if @ghostscript_path

      result = `#{command.join(' ')}`

      $? == 0 || raise(UnprocessablePage, result)
    end
  end
end
