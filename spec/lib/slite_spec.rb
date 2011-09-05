require 'fileutils'
require 'spec_helper'

describe Slite do
  after(:all) do
    FileUtils.rm_rf(tmp_dir)
  end

  it "should have a VERSION constant" do
    Slite.const_defined?('VERSION').should be_true
  end

  describe "Pdf" do
    describe "#initialize" do
      it "should raise an error if pdf does not exist" do
        lambda { Slite::Pdf.new(fixture_path("booboo.pdf")) }.should raise_error(Slite::PdfNotFound)
      end
    end

    describe "#page_count" do
      it "should return an integer" do
        instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
        instance.page_count.should == 25
      end
    end

    describe "#page" do
      it "should be set to 1 by default" do
        instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
        instance.page_number.should == 1
      end

      it "should set page attribute and return instance" do
        instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
        instance.page(2).should == instance
        instance.page_number.should == 2
      end
    end

    describe "#index" do
      it "should return page minus 1" do
        instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
        instance.page(2)
        instance.index.should == 1
      end
    end

    describe "#to_image" do
      describe "output png" do
        before(:all) do
          instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
          @png = instance.to_image(tmp_path("to_png_spec.png"))
        end

        it "should create the file" do
          File.exist?(tmp_path("to_png_spec.png")).should be_true
        end

        it "should return an instance of File" do
          @png.class.should == File
        end

        it "should have the right file size" do
          @png.stat.size.should == 188515
        end
      end

      describe "output jpeg" do
        before(:all) do
          instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
          @jpeg = instance.to_image(tmp_path("to_jpeg_spec.jpeg"))
        end

        it "should create the file" do
          File.exist?(tmp_path("to_jpeg_spec.jpeg")).should be_true
        end

        it "should return an instance of File" do
          @jpeg.class.should == File
        end

        it "should have the right file size" do
          @jpeg.stat.size.should == 53980
        end
      end
    end
  end
end