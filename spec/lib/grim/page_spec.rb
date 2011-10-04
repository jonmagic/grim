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
      @pdf  = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should call Grim.processor.save with pdf, index, path, and options" do
      Grim.processor.should_receive(:save).with(@pdf, 0, @path, {})
      @pdf[0].save(@path)
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

  # describe "#save with an unprocessable PDF" do
  #   let(:path) { tmp_path("unprocessable.jpg") }
  #   let(:pdf)  { Grim::Pdf.new(fixture_path("unprocessable.pdf")) }
  #
  #   it "should raise an error" do
  #     lambda { pdf[0].save(path) }.should raise_error(Grim::UnprocessablePage, /missing an image filename/)
  #   end
  # end

  describe "#text" do
    it "should return the text from the selected page" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf[1].text.should == "Step 1: get someone to print this curve for you to scale, 72\342\200\235 wide\n\nStep 2: Get a couple 55 gallon drums\n\n\f"
    end
  end
end