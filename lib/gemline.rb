require 'crack/json'
require 'net/http'

class Gemline

  def self.query(gem)
    gem = gem.to_s.gsub(/[^\w\-]+/,'')
    if (gem.empty? || ['-h','--help','help'].include?(gem))
      puts "Usage: gemline [GEM NAME]"
      puts "  Prints a Gemfile require line for a Ruby gem on Rubygems.org"
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
