require 'crack/json'
require 'net/http'

class Gemline
  VERSION = "0.0.1"

  gem = ARGV[0].to_s.gsub(/[^\w\-]+/,'')
  doc = Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/gems/#{gem}.json"))
  response = Crack::JSON.parse(doc)
  gemline = %Q{gem "#{gem}", "~> #{response['version']}"}  

  puts gemline

  begin
    IO.popen('pbcopy', 'r+') do |clipboard|
      clipboard.puts gemline
      puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
    end
  rescue
  end
end
