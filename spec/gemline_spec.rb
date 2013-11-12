require 'spec_helper'

describe Gemline do

  describe "querying rubygems" do

    before do
      stub_rubygems_json_output
    end

    it "should be able to parse the version out of a good json string" do
      g = Gemline.new('rails')
      expect(g.gemline).to eq(%Q{gem "rails", "~> 4.0.0"})
    end

    it "should whine when the gem you are querying does not exist" do
      g = Gemline.new('doesnotexist')
      expect(g.gem_not_found?).to be_true
      expect(g.gemline).to be_nil
    end

    it "should properly detect a blocked gem name" do
      g = Gemline.new('yaml')
      expect(g.gem_not_found?).to be_true
      expect(g.gemline).to be_nil
    end

    it "should properly handle funny characters in the returned JSON" do
      g = Gemline.new('nokogiri')
      expect(g.gemline).to eq(%Q{gem "nokogiri", "~> 1.6.0"})
    end

    it "should be able to generate a gemspec-style gemline" do
      g = Gemline.new('rails', :gemspec => true)
      expect(g.gemline).to eq(%Q!gem.add_dependency "rails", "~> 4.0.0"!)
    end

    describe "generates a development gemspec-style gemline" do
      it "works when just passed the development group" do
        g = Gemline.new('nokogiri', {:gemspec => true, :group => 'development'})
        expect(g.gemline).to eq(%Q!gem.add_development_dependency "nokogiri", "~> 1.6.0"!)
      end
      it "works when passed other groups also" do
        g = Gemline.new('nokogiri', {:gemspec => true, :group => 'development,test'})
        expect(g.gemline).to eq(%Q!gem.add_development_dependency "nokogiri", "~> 1.6.0"!)
      end
    end

    it "should be able to add options to a gemfile-style gemline" do
      g = Gemline.new('nokogiri', {:git => "some git repo", :group => [:development, :test]})
      line = g.gemline
      expect(line).to start_with(%Q{gem "nokogiri", "~> 1.6.0", })
      expect(line).to include(%Q{:git => "some git repo"})
      expect(line).to include(%Q{:group => [:development, :test]})
    end

    it "should be able to return prerelease gem versions" do
      g = Gemline.new('rails', :pre => true)
      expect(g.gemline).to eq(%Q{gem "rails", "~> 4.0.1.rc4"})
    end

  end

  describe 'helper methods' do
    describe '#options_to_string' do
      it "returns nothing when no options provided" do
        expect(Gemline.options_to_string).to eq ''
      end

      describe "gem groups" do
        it "handles a single group as a symbol" do
          expect(Gemline.options_to_string :group => :development).to eq ':group => :development'
        end

        it "handles a single group as a string" do
          expect(Gemline.options_to_string :group => 'development').to eq ':group => :development'
        end

        it "handles a list of groups as symbols" do
          expect(Gemline.options_to_string :group => [:development, :test]).to eq ':group => [:development, :test]'
        end

        it "handles a list of groups as strings" do
          expect(Gemline.options_to_string :group => ['development','test']).to eq ':group => [:development, :test]'
        end
      end
    end
  end

end
