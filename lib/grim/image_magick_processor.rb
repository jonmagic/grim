require 'open3'

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

      command_env = {}

      if @ghostscript_path && @ghostscript_path != DefaultGhostScriptPath
        command_env['PATH'] = "#{File.dirname(@ghostscript_path)}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
      end

      log(command_env, command)
      result, status = Open3.capture2e(command_env, command.join(" "))

      status.success? || raise(UnprocessablePage, result)
    end

    def log(command_env, command)
      Grim.logger.debug "Running imagemagick command"
      if command_env.any?
        Grim.logger.debug command_env.map {|k,v| "#{k}=#{v}" }.join(" ")
      end
      Grim.logger.debug command.join(" ")
    end
  end
end
