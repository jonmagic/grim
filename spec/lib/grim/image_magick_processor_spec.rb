# encoding: UTF-8
require 'spec_helper'

describe Grim::ImageMagickProcessor do
  before(:each) do
    @reset_to  = ENV['PATH']
  end

  after(:each) do
    ENV['PATH'] = @reset_to
  end

  describe "#count" do
    before(:each) do
      @processor = Grim::ImageMagickProcessor.new
    end

    it "should return page count" do
      @processor.count(fixture_path("smoker.pdf")).should == 25
    end
  end

  describe "#save" do
    before(:all) do
      @path = tmp_path("to_png_spec.png")
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))

      @processor = Grim::ImageMagickProcessor.new
    end

    it "should create the file" do
      @processor.save(@pdf, 0, @path, {})
      File.exist?(@path).should be_true
    end

    it "should use default width of 1024" do
      @processor.save(@pdf, 0, @path, {})
      width, height = dimensions_for_path(@path)
      width.should == 1024
    end
  end

  describe "#save with width option" do
    before(:each) do
      @path = tmp_path("to_png_spec.png")
      pdf   = Grim::Pdf.new(fixture_path("smoker.pdf"))

      Grim::ImageMagickProcessor.new.save(pdf, 0, @path, {:width => 20})
    end

    it "should set width" do
      width, height = dimensions_for_path(@path)
      width.should == 20
    end
  end

  describe "#save with quality option" do
    before(:each) do
      @path = tmp_path("to_png_spec.jpg")
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should use quality" do
      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path, {:quality => 20})
      lower_size = File.size(@path)

      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path, {:quality => 90})
      higher_size = File.size(@path)

      (lower_size < higher_size).should be_true
    end
  end

  describe "#save with density option" do
    before(:each) do
      @path = tmp_path("to_png_spec.jpg")
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should use density" do
      lower_time  = Benchmark.realtime { Grim::ImageMagickProcessor.new.save(@pdf, 0, @path, {:density => 72}) }
      higher_time = Benchmark.realtime { Grim::ImageMagickProcessor.new.save(@pdf, 0, @path, {:density => 300}) }

      (lower_time < higher_time).should be_true
    end
  end
end