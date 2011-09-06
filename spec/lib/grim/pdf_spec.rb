require 'spec_helper'

describe Grim::Pdf do
  describe "#initialize" do
    it "should raise an error if pdf does not exist" do
      lambda { Grim.new(fixture_path("booboo.pdf")) }.should raise_error(Grim::PdfNotFound)
    end

    it "should set path on pdf" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf.path.should == fixture_path("smoker.pdf")
    end
  end

  describe "#count" do
    it "should return 25" do
      pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
      pdf.count.should == 25
    end
  end

  describe "#[]" do
    before(:each) do
      @pdf = Grim::Pdf.new(fixture_path("smoker.pdf"))
    end

    it "should raise Grim::PageDoesNotExist if page doesn't exist" do
      lambda { @pdf[25] }.should raise_error(Grim::PageNotFound)
    end

    it "should return an instance of Grim::Page if page exists" do
      @pdf[24].class.should == Grim::Page
    end
  end

end