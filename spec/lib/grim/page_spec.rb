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
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf[0].save(tmp_path("to_png_spec.png"))
      @file = File.open(tmp_path("to_png_spec.png"))
    end

    it "should create the file" do
      File.exist?(tmp_path("to_png_spec.png")).should be_true
    end

    it "should use default width of 1024" do
      width, height = dimensions_for_path(@file.path)
      width.should == 1024
    end
  end

  describe "#text" do
    it "should return the text from the selected page" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf[1].text.should == "Step 1: get someone to print this curve for you to scale, 72\342\200\235 wide\n\nStep 2: Get a couple 55 gallon drums\n\n\f"
    end
  end
end