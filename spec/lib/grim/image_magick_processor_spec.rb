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
      expect(@processor.count(fixture_path("smoker.pdf"))).to eq(25)
    end
  end

  describe "#count with windows executable", :windows => true do
    before(:each) do
      @processor = Grim::ImageMagickProcessor.new({:ghostscript_path => "gswin64c.exe"})
    end

    it "should return page count" do
      expect(@processor.count(fixture_path("smoker.pdf"))).to eq(25)
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
      expect(File.exist?(@path)).to be(true)
    end

    it "should use default width of 1024" do
      @processor.save(@pdf, 0, @path, {})
      width, height = dimensions_for_path(@path)
      expect(width).to eq(1024)
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
      expect(width).to eq(20)
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

      expect(lower_size < higher_size).to be(true)
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

      expect(lower_time < higher_time).to be(true)
    end
  end

  describe "#save with colorspace option" do
    before(:each) do
      @path1 = tmp_path("to_png_spec-1.jpg")
      @path2 = tmp_path("to_png_spec-2.jpg")
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should use colorspace" do
      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path1, {:colorspace => 'RGB'})
      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path2, {:colorspace => 'sRGB'})

      file1_size = File.stat(@path1).size
      file2_size = File.stat(@path2).size

      expect(file1_size).to_not eq(file2_size)
    end
  end
  
  describe "#save with alpha option" do
    before(:each) do
      @path1 = tmp_path("to_png_spec-1.png")
      @path2 = tmp_path("to_png_spec-2.png")
      @pdf  = Grim::Pdf.new(fixture_path("remove_alpha.pdf"))
    end
    
    it "should use alpha" do
      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path1, {:alpha => 'Set'})
      Grim::ImageMagickProcessor.new.save(@pdf, 0, @path2, {:alpha => 'Remove'})

      expect(`convert #{@path1} -verbose info:`.include?("alpha: 8-bit")).to be(true)
      expect(`convert #{@path2} -verbose info:`.include?("alpha: 1-bit")).to be(true)
    end
  end
end
