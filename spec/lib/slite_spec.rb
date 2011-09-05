require 'spec_helper'
describe Slite do
  it "should have a VERSION constant" do
    Slite.const_defined?('VERSION').should be_true
  end

  describe "Pdf" do
    describe "#initialize" do
      it "should raise an error if pdf does not exist" do
        lambda { Slite::Pdf.new(fixture_path("booboo.pdf")) }.should raise_error
      end
    end

    describe "#page_count" do
      it "should return an integer" do
        instance = Slite::Pdf.new(fixture_path("smoker.pdf"))
        instance.page_count.should == 25
      end
    end
  end
end