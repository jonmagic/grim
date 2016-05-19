module Grim
  class ImageMagickProcessor

    # ghostscript prints out a warning, this regex matches it
    WarningRegex = /\*\*\*\*.*\n/
    DefaultImagemagickPath = 'convert'
    DefaultGhostScriptPath = 'gs'

    def initialize(options={})
      @imagemagick_path = options[:imagemagick_path] || DefaultImagemagickPath
      @ghostscript_path = options[:ghostscript_path] || DefaultGhostScriptPath
      @original_path    = ENV['PATH']
    end

    def count(path)
      command = [@ghostscript_path, "-dNODISPLAY", "-q",
        "-sFile=#{Shellwords.shellescape(path)}",
        File.expand_path('../../../lib/pdf_info.ps', __FILE__)]
      result = `#{command.join(' ')}`
      result.gsub(WarningRegex, '').to_i
    end

    def save(pdf, index, path, options)
      width      = options.fetch(:width,   Grim::WIDTH)
      density    = options.fetch(:density, Grim::DENSITY)
      quality    = options.fetch(:quality, Grim::QUALITY)
      colorspace = options.fetch(:colorspace, Grim::COLORSPACE)
      alpha      = options[:alpha]

      command = []
      command << @imagemagick_path
      command << "-resize #{width}"
      command << "-alpha #{alpha}" if alpha
      command << "-antialias"
      command << "-render"
      command << "-quality #{quality}"
      command << "-colorspace #{colorspace}"
      command << "-interlace none"
      command << "-density #{density}"
      command << "#{Shellwords.shellescape(pdf.path)}[#{index}]"
      command << path

      ENV['PATH'] = "#{File.dirname(@ghostscript_path)}#{File::PATH_SEPARATOR}#{ENV['PATH']}" if @ghostscript_path && @ghostscript_path != DefaultGhostScriptPath

      result = `#{command.join(' ')}`
      
      ENV['PATH'] = @original_path if @ghostscript_path && @ghostscript_path != DefaultGhostScriptPath
      
      $? == 0 || raise(UnprocessablePage, result)
    end
  end
end
