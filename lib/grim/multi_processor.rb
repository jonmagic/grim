module Grim
  class MultiProcessor
    def initialize(processors)
      @processors = processors
    end

    def count(path)
      result = ""
      for i in 0..(@processors.length - 1)
        result = @processors[i].count(path)
        break if result != ""
      end
      result
    end

    def save(pdf, index, path, options)
      result = true
      for i in 0..(@processors.length - 1)
        result = @processors[i].save(pdf, index, path, options)
        break if result
      end
      raise UnprocessablePage unless result
    end
  end
end