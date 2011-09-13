# encoding: UTF-8
require 'fileutils'
require 'spec_helper'

describe Grim::Page do
  after(:all) do
    FileUtils.rm_rf(tmp_dir)
  end

  it "should have number" do
    Grim::Page.new(Grim::Pdf.new(fixture_path("smoker.pdf")), 1).number.should == 2
  end

  describe "#save" do
    before(:all) do
      @path = tmp_path("to_png_spec.png")
      pdf   = Grim::Pdf.new(fixture_path("smoker.pdf"))

      pdf[0].save(@path)
    end

    it "should create the file" do
      File.exist?(@path).should be_true
    end

    it "should use default width of 1024" do
      width, height = dimensions_for_path(@path)
      width.should == 1024
    end
  end

  describe "#save with empty path" do
    before(:each) do
      @path = tmp_path("to_png_spec.png")
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "raises an exception" do
      lambda { @pdf[0].save(nil) }.should raise_error(Grim::PathMissing)
      lambda { @pdf[0].save('  ') }.should raise_error(Grim::PathMissing)
    end
  end

  describe "#save with width option" do
    before(:each) do
      @path = tmp_path("to_png_spec.png")
      pdf   = Grim::Pdf.new(fixture_path("smoker.pdf"))

      pdf[0].save(@path, :width => 20)
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
      @pdf[0].save(@path, :quality => 20)
      lower_size = File.size(@path)

      @pdf[0].save(@path, :quality => 90)
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
      lower_time  = Benchmark.realtime { @pdf[0].save(@path, :density => 20) }
      higher_time = Benchmark.realtime { @pdf[0].save(@path, :density => 300) }

      (lower_time < higher_time).should be_true
    end
  end

  describe "#save with an unprocessable PDF" do
    let(:path) { tmp_path("unprocessable.jpg") }
    let(:pdf)  { Grim::Pdf.new(fixture_path("unprocessable.pdf")) }

    it "should raise an error" do
      lambda { pdf[0].save(path) }.should raise_error(Grim::UnprocessablePage, /missing an image filename/)
    end
  end

  describe "#text" do
    it "should return the text from the selected page" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf[1].text.should == "Step 1: get someone to print this curve for you to scale, 72\342\200\235 wide\n\nStep 2: Get a couple 55 gallon drums\n\n\f"
    end
  end
end