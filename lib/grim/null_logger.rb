require "logger"

module Grim
  class NullLogger
    def initialize(*args); end
    def debug(*args); end
    def info(*args); end
  end
end
