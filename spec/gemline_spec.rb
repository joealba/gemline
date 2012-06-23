require 'spec_helper'

describe Gemline do

  describe "querying rubygems" do

    before do     
      Dir.glob(File.join(File.dirname(__FILE__),'samples', '*.json')).each do |f|
        gem_name = $1 if f =~ /\/([\w\-]+).json$/
        Gemline.stub!(:get_rubygem_json).with(gem_name).and_return(IO.read(f))
      end
    end

    it "should be able to parse the version out of a good json string" do
      g = Gemline.new('rails')
      g.gemline.should == %Q{gem "rails", "~> 3.1.1"}
    end
    
    it "should whine when the gem you are querying does not exist" do
      g = Gemline.new('doesnotexist')
      g.gem_not_found?.should be_true
      g.gemline.should be_nil
    end

    it "should properly detect a blocked gem name" do
      g = Gemline.new('yaml')
      g.gem_not_found?.should be_true
      g.gemline.should be_nil
    end

    it "should properly handle funny characters in the returned JSON" do
      g = Gemline.new('nokogiri')
      g.gemline.should == %Q{gem "nokogiri", "~> 1.5.5"}
    end
  end

end
