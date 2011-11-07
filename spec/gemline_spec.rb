require 'spec_helper'

describe Gemline do

  describe "querying rubygems" do

    before do      
      ['rails','doesnotexist'].each do |arg|
        Gemline.stub!(:get_rubygem_json).with(arg).and_return(IO.read(File.join(File.dirname(__FILE__),'samples',"#{arg}.json")))
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
  end

end
