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

    it "should call modify_path" do
      @processor.should_receive(:modify_path)
      @processor.count(fixture_path("smoker.pdf"))
    end

    it "should call release_path" do
      @processor.should_receive(:release_path)
      @processor.count(fixture_path("smoker.pdf"))
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

    it "should call modify_path" do
      SafeShell.stub(:execute){true}
      @processor.should_receive(:modify_path)
      @processor.save(@pdf, 0, @path, {})
    end

    it "should call release_path" do
      SafeShell.stub(:execute){true}
      @processor.should_receive(:release_path)
      @processor.save(@pdf, 0, @path, {})
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

  describe "#modify_path" do
    describe "imagemagick_bin_path set" do
      it "should add /path/to/convert/ to beginning of path" do
        processor = Grim::ImageMagickProcessor.new({:imagemagick_bin_path => '/path/to/convert/'})
        processor.modify_path
        ENV['PATH'].split(':')[0].should == '/path/to/convert/'
      end

      after(:each) do
        ENV['PATH'] = @reset_to
      end
    end

    describe "ghostscript_bin_path set" do
      it "should add /path/to/convert/ to beginning of path" do
        processor = Grim::ImageMagickProcessor.new({:ghostscript_bin_path => '/path/to/gs/'})
        processor.modify_path
        ENV['PATH'].split(':')[0].should == '/path/to/gs/'
      end

      after(:each) do
        ENV['PATH'] = @reset_to
      end
    end

    describe "imagemagick_bin_path and ghostscript_bin_path set" do
      it "should add /path/to/convert/ to beginning of path" do
        processor = Grim::ImageMagickProcessor.new({:imagemagick_bin_path => '/path/to/convert/', :ghostscript_bin_path => '/path/to/gs/'})
        processor.modify_path
        ENV['PATH'].split(':')[0].should == '/path/to/gs/'
        ENV['PATH'].split(':')[1].should == '/path/to/convert/'
      end

      after(:each) do
        ENV['PATH'] = @reset_to
      end
    end
  end

  describe "#release_path" do
    before(:each) do
      ENV['PATH'] = '/grim/reaper/:/the/scythe/is/inevitable/'
      @processor = Grim::ImageMagickProcessor.new({:imagemagick_bin_path => '/path/to/convert/', :ghostscript_bin_path => '/path/to/gs/'})
      @processor.modify_path
    end

    it "should set path back to original" do
      ENV['PATH'].should == '/path/to/gs/:/path/to/convert/:/grim/reaper/:/the/scythe/is/inevitable/'
      @processor.release_path
      ENV['PATH'].should == '/grim/reaper/:/the/scythe/is/inevitable/'
    end
  end
end