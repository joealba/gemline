require 'crack/json'
require 'net/http'

class Gemline
  VERSION = "0.0.1"

  def self.start
    gem = ARGV[0].to_s.gsub(/[^\w\-]+/,'')
    if (gem.empty?)
      puts "Usage: gemline [GEM NAME]"
      exit
    end
  
    doc = Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/gems/#{gem}.json"))

    if doc.match(/could not be found/)
      puts "Rubygem #{gem} was not found on rubygems.org"
      exit
    else
      response = Crack::JSON.parse(doc)
      gemline = %Q{gem "#{gem}", "~> #{response['version']}"}  

      puts gemline

      begin
        if clipboard = IO.popen('pbcopy', 'r+')
          clipboard.puts gemline
          puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
        end
      rescue
      end
    end
  end

end
