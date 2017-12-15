require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'gemline'

require 'bundler'
Bundler.setup


RSpec.configure do |c|
  # c.mock_with :rr
end


def stub_rubygems_json_output
  Dir.glob(File.join(File.dirname(__FILE__),'samples', '*.json')).each do |f|
    gem_name = $1 if f =~ /\/([\w\-]+).json$/
    allow(Gemline).to receive(:get_rubygem_json).with(gem_name).and_return(IO.read(f))
  end
end

def grab_io
  @stdout = StringIO.new; $stdout = @stdout;
  @stderr = StringIO.new; $stderr = @stderr;

  yield

  @stdout.rewind; @stderr.rewind;

  $stdout = STDOUT
  $stderr = STDERR
end
