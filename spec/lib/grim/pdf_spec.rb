# encoding: UTF-8
require 'spec_helper'

describe Grim::Pdf do

  it "should have a path" do
    pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
    expect(pdf.path).to eq(fixture_path("smoker.pdf"))
  end

  describe "#initialize" do
    it "should raise an error if pdf does not exist" do
      expect {
        Grim::Pdf.new(fixture_path("booboo.pdf"))
      }.to raise_error(Grim::PdfNotFound)
    end

    it "should set path on pdf" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      expect(pdf.path).to eq(fixture_path("smoker.pdf"))
    end
  end

  describe "#count" do
    it "should call Grim.processor.count with pdf path" do
      expect(Grim.processor).to receive(:count).with(fixture_path("smoker.pdf"))
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf.count
    end
  end

  describe "#[]" do
    before(:each) do
      @pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should raise Grim::PageDoesNotExist if page doesn't exist" do
      expect { @pdf[25] }.to raise_error(Grim::PageNotFound)
    end

    it "should return an instance of Grim::Page if page exists" do
      expect(@pdf[24].class).to eq(Grim::Page)
    end
  end

  describe "#each" do
    it "should be iterable" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      expect(pdf.map {|p| p.number }).to eq((1..25).to_a)
    end
  end

end
