# encoding: UTF-8
require 'spec_helper'

describe Grim do
  it "should have a default processor" do
    expect(Grim.processor.class).to eq(Grim::ImageMagickProcessor)
  end

  it "should have a VERSION constant" do
    expect(Grim.const_defined?('VERSION')).to be(true)
  end

  it "should have WIDTH constant set to 1024" do
    expect(Grim::WIDTH).to eq(1024)
  end

  it "should have QUALITY constant set to 90" do
    expect(Grim::QUALITY).to eq(90)
  end

  it "should have DENSITY constant set to 300" do
    expect(Grim::DENSITY).to eq(300)
  end

  it "should have COLORSPACE constant set to 'RGB'" do
    expect(Grim::COLORSPACE).to eq('RGB')
  end

  describe "#reap" do
    it "should return an instance of Grim::Pdf" do
      expect(Grim.reap(fixture_path("smoker.pdf")).class).to eq(Grim::Pdf)
    end
  end
end
