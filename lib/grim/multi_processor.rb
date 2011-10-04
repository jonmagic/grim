module Grim
  class MultiProcessor
    def initialize(processors)
      @processors = processors
    end

    def count(path)
      result = ""
      @processors.each do |processor|
        result = processor.count(path)
        break if result != ""
      end
      result
    end

    def save(pdf, index, path, options)
      result = true
      @processors.each do |processor|
        begin
          result = processor.save(pdf, index, path, options)
        rescue UnprocessablePage
          next
        end
        break if result
      end
      raise UnprocessablePage unless result
    end
  end
end