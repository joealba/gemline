require 'spec_helper'

describe Gemline do

  describe "querying rubygems" do

    before do
      stub_rubygems_json_output
    end

    it "should be able to parse the version out of a good json string" do
      g = Gemline.new('rails')
      expect(g.gemline).to eq(%Q{gem "rails", "~> 3.1.1"})
    end

    it "should whine when the gem you are querying does not exist" do
      g = Gemline.new('doesnotexist')
      g.gem_not_found?.should be_true
      expect(g.gemline).to be_nil
    end

    it "should properly detect a blocked gem name" do
      g = Gemline.new('yaml')
      expect(g.gem_not_found?).to be_true
      expect(g.gemline).to be_nil
    end

    it "should properly handle funny characters in the returned JSON" do
      g = Gemline.new('nokogiri')
      expect(g.gemline).to eq(%Q{gem "nokogiri", "~> 1.5.5"})
    end

    it "should be able to generate a gemspec-style gemline" do
      g = Gemline.new('rails', :gemspec => true)
      expect(g.gemline).to eq(%Q!gem.add_dependency "rails", "~> 3.1.1"!)
    end

    describe "generates a development gemspec-style gemline" do
      it "works when just passed the development group" do
        g = Gemline.new('nokogiri', {:gemspec => true, :group => :development})
        expect(g.gemline).to eq(%Q!gem.add_development_dependency "nokogiri", "~> 1.5.5"!)
      end
      it "works when passed other groups also" do
        g = Gemline.new('nokogiri', {:gemspec => true, :group => 'development,test'})
        expect(g.gemline).to eq(%Q!gem.add_development_dependency "nokogiri", "~> 1.5.5"!)
      end
    end

    it "should be able to add options to a gemfile-style gemline" do
      g = Gemline.new('nokogiri', {:git => "some git repo", :group => [:development, :test]})
      line = g.gemline
      expect(line).to start_with(%Q{gem "nokogiri", "~> 1.5.5", })
      expect(line).to include(%Q{:git => "some git repo"})
      expect(line).to include(%Q{:group => [:development, :test]})
    end

  end

end
