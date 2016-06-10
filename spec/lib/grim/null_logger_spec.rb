require 'spec_helper'
require "stringio"

describe Grim::NullLogger do
  it "acts like Logger but doesn't log anything" do
    io = StringIO.new
    logger = Grim::NullLogger.new(io)
    logger.debug "hello world"
    expect(io.string).to eq("")
  end
end
