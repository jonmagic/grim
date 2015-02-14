# encoding: UTF-8
require 'spec_helper'

describe Grim::MultiProcessor do
  before(:each) do
    @failure     = Grim::ImageMagickProcessor.new
    @success     = Grim::ImageMagickProcessor.new
    @extra       = Grim::ImageMagickProcessor.new
    @processor  = Grim::MultiProcessor.new([@failure, @success, @extra])

    @path = fixture_path("smoker.pdf")
    @pdf  = Grim::Pdf.new(@path)
  end

  describe "#count" do
    it "should try processors until it succeeds" do
      allow(@failure).to receive(:count).and_return("")
      expect(@success).to receive(:count).and_return(30)
      expect(@extra).to_not receive(:count)

      @processor.count(@path)
    end
  end

  describe "#save" do
    it "should try processors until it succeeds" do
      allow(@failure).to receive(:save).and_return(false)
      expect(@success).to receive(:save).and_return(true)
      expect(@extra).to_not receive(:save)

      @processor.save(@pdf, 0, @path, {})
    end

    it "should raise error if all processors fail" do
      expect(@failure).to receive(:save).and_return(false)
      expect(@success).to receive(:save).and_return(false)
      expect(@extra).to receive(:save).and_return(false)

      expect { @processor.save(@pdf, 0, @path, {}) }.to raise_error(Grim::UnprocessablePage)
    end
  end
end
