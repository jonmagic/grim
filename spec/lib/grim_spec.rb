# encoding: UTF-8
require 'spec_helper'

describe Grim do
  it "should have a VERSION constant" do
    Grim.const_defined?('VERSION').should be_true
  end

  it "should have WIDTH constant set to 1024" do
    Grim::WIDTH.should == 1024
  end

  it "should have QUALITY constant set to 90" do
    Grim::QUALITY.should == 75
  end

  it "should have DENSITY constant set to 300" do
    Grim::DENSITY.should == 150
  end

  describe "#new" do
    it "should return an instance of Grim::Pdf" do
      Grim.reap(fixture_path("smoker.pdf")).class.should == Grim::Pdf
    end
  end
end