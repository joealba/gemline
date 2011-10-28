require 'gemline/version'
require 'thor'
require 'crack'
require 'net/http'

class Gemline < Thor
  default_task :query

  def query
    gem = ARGV[0].to_s.gsub(/[^\w\-]+/,'')
    url = "https://rubygems.org/api/v1/gems/#{gem}.json"
    doc = Net::HTTP.get(URI.parse(url))
    response = Crack.parse(doc)
    puts %Q{gem #{gem}, "~> #{response[:version]}"}
  end
  
  
#  Gemline.start
end
