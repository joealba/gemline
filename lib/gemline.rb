#require 'gemline/version'
require 'crack/json'
require 'net/http'

class Gemline
  VERSION = "0.0.1"

  gem = ARGV[0].to_s.gsub(/[^\w\-]+/,'')
  doc = Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/gems/#{gem}.json"))
  response = Crack::JSON.parse(doc)
  puts %Q{gem "#{gem}", "~> #{response['version']}"}  
end
