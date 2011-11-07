$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'gemline'

require 'bundler'
Bundler.setup


RSpec.configure do |c|

end
