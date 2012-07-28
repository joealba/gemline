require 'spec_helper'
require 'stringio'

describe "gemline output" do

  before do     
    stub_rubygems_json_output
  end

  it "should output one line to STDOUT so the output can be appended to a Gemfile" do
    grab_io { Gemline.query('rails') }
    @stdout.readlines.count.should eq(1)
  end

  it "should output nothing to STDOUT on error" do
    Kernel.stub(:exit)
    grab_io { Gemline.query('doesnotexist') }
    @stdout.readlines.count.should eq(0)
  end

end
