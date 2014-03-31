module Grim
  class ImageMagickProcessor

    # ghostscript prints out a warning, this regex matches it
    WarningRegex = /\*\*\*\*.*\n/

    def initialize(options={})
      @imagemagick_path = options[:imagemagick_path] || 'convert'
      @ghostscript_path = options[:ghostscript_path]
      @original_path        = ENV['PATH']
    end

    def count(path)
      command = ["-dNODISPLAY", "-q",
        "-sFile=#{Shellwords.shellescape(path)}",
        File.expand_path('../../../lib/pdf_info.ps', __FILE__)]
      @ghostscript_path ? command.unshift(@ghostscript_path) : command.unshift('gs')
      result = `#{command.join(' ')}`
      result.gsub(WarningRegex, '').to_i
    end

    def save(pdf, index, path, options={})
      result = `#{command(pdf, index, path, options)}`

      $? == 0 || raise(UnprocessablePage, result)
    end

    private

    def command(pdf, index, path, options)
      # Default options.
      command  = [@imagemagick_path]
      command += ["-antialias"]
      command += ["-render"]
      command += ["-interlace", "none"]

      # Overrideable default options.
      command += ["-resize", options.fetch(:width, Grim::WIDTH).to_s]
      command += ["-quality", options.fetch(:quality, Grim::QUALITY).to_s]
      command += ["-colorspace", options.fetch(:colorspace, Grim::COLORSPACE).to_s]
      command += ["-density", options.fetch(:density, Grim::DENSITY).to_s]

      # Extra options.
      Array(options[:extra]).each do |extra_option|
        command << extra_option
      end

      # Output path (escaped because we don't have control over the incoming filename).
      command += ["#{Shellwords.shellescape(pdf.path)}[#{index}]", path]

      # Add ghostscript to PATH if it has been manually set.
      command.unshift("PATH=#{File.dirname(@ghostscript_path)}:#{ENV['PATH']}") if @ghostscript_path

      # And finally return the compiled command.
      command.join(' ')
    end
  end
end
