require 'crack/json'
require 'net/http'


class Gemline
  attr_accessor :gem, :gemline, :json, :response

  def self.query(gem)
    gem = gem.to_s.gsub(/[^\w\-]+/,'')
    check_input(gem)

    g = Gemline.new(gem)
      
    if g.gem_not_found?
      puts "Rubygem #{gem} was not found on rubygems.org"
      exit
    else
      puts g.gemline
      copy_to_clipboard(g.gemline)
    end
  end


  def initialize(gem)
    @gem = gem.to_s.gsub(/[^\w\-]+/,'') # Yeah, a little over-defensive.
    @json = Gemline.get_rubygem_json(@gem)
    unless gem_not_found?
      @response = Crack::JSON.parse(@json)
      @gemline = Gemline.create_gemline(@gem, response['version'])
    end
  end

  def gem_not_found?
    @json.match(/could not be found/)
  end
  
  
  private
  
  def self.get_rubygem_json(gem)
    Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/gems/#{gem}.json"))
  end  

  def self.create_gemline(gem, version)
    %Q{gem "#{gem}", "~> #{version}"}  
  end

  def self.check_input(gem)
    if (gem.empty? || ['-h','--help','help'].include?(gem))
      puts "Usage: gemline [GEM NAME]"
      puts "  Prints a Gemfile require line for a Ruby gem on Rubygems.org"
      exit
    end
    
    # if (['-v','--version'].include?(gem))
    #   puts "gemline #{Gemline::VERSION}"
    #   exit
    # end
  end

  def self.copy_to_clipboard(gemline)
    begin
      if clipboard = IO.popen('pbcopy', 'r+')
        clipboard.puts gemline
        puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
      end
    rescue
    end
  end

end
