require 'fileutils'
require 'spec_helper'

describe Grim::Page do
  after(:all) do
    FileUtils.rm_rf(tmp_dir)
  end

  describe "#image" do
    describe "output png" do
      before(:all) do
        pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
        @png = pdf[0].image(tmp_path("to_png_spec.png"))
      end

      it "should create the file" do
        File.exist?(tmp_path("to_png_spec.png")).should be_true
      end

      it "should return an pdf of File" do
        @png.class.should == File
      end

      it "should have the right file size" do
        @png.stat.size.should == 188515
      end
    end

    describe "output jpeg" do
      before(:all) do
        pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
        @jpeg = pdf[0].image(tmp_path("to_jpeg_spec.jpeg"))
      end

      it "should create the file" do
        File.exist?(tmp_path("to_jpeg_spec.jpeg")).should be_true
      end

      it "should return an pdf of File" do
        @jpeg.class.should == File
      end

      it "should have the right file size" do
        @jpeg.stat.size.should == 53980
      end
    end
  end

  describe "#text" do
    it "should return the text from the selected page" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf[1].text.should == "Step 1: get someone to print this curve for you to scale, 72\342\200\235 wide\n\nStep 2: Get a couple 55 gallon drums\n\n\f"
    end
  end
end