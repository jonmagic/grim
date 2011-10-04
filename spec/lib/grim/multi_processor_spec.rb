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
      @failure.stub(:count){""}
      @success.should_receive(:count).and_return(30)
      @extra.should_not_receive(:count)

      @processor.count(@path)
    end
  end

  describe "#save" do
    it "should try processors until it succeeds" do
      @failure.stub(:save){false}
      @success.should_receive(:save).and_return(true)
      @extra.should_not_receive(:save)

      @processor.save(@pdf, 0, @path, {})
    end

    it "should raise error if all processors fail" do
      @failure.should_receive(:save).and_return(false)
      @success.should_receive(:save).and_return(false)
      @extra.should_receive(:save).and_return(false)

      lambda { @processor.save(@pdf, 0, @path, {}) }.should raise_error(Grim::UnprocessablePage)
    end
  end
end