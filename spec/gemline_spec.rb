require 'spec_helper'

describe Gemline do

  describe "querying rubygems" do

    before do     
      stub_rubygems_json_output
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

    it "should be able to generate a gemspec-style gemline" do
      g = Gemline.new('rails', :gemspec => true)
      g.gemline.should == %Q!gem.add_dependency(%q<rails>, ["~> 3.1.1"])!
    end

  end

end
