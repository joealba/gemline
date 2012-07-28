require 'crack/json'
require 'net/http'

require 'yaml'
YAML::ENGINE.yamler = 'syck' if RUBY_VERSION[0,3] == "1.9"


class Gemline
  attr_accessor :gem, :gemline, :json, :response

  def self.query(gem_name)
    gem_name = gem_name.to_s.gsub(/[^\w\-]+/,'')
    check_input(gem_name)

    g = Gemline.new(gem_name)
    
    if g.gem_not_found?
      $stderr.puts "Ruby gem #{gem_name} was not found on rubygems.org"
      Kernel.exit 1
    else
      puts g.gemline
      copy_to_clipboard(g.gemline)
    end
  end


  def initialize(gem_name, options = {})
    @gem = gem_name.to_s.gsub(/[^\w\-]+/,'') # Yeah, a little over-defensive.
    @json = Gemline.get_rubygem_json(@gem)
    unless gem_not_found?
      @response = Crack::JSON.parse(@json)
      @gemline = Gemline.create_gemline(@gem, response['version'], options)
    end
  end

  def gem_not_found?
    @json.match(/(could not be found|does not exist)/)
  end
  
  
  private
  
  def self.get_rubygem_json(gem_name)
    Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/gems/#{gem_name}.json"))
  end  

  def self.create_gemline(gem_name, version, options = {})
    if options[:gemspec]
      return gemspec_gemline(gem_name, version)
    else
      return gemfile_gemline(gem_name, version)
    end
  end

  def self.gemfile_gemline(gem_name, version)
    %Q{gem "#{gem_name}", "~> #{version}"}  
  end

  def self.gemspec_gemline(gem_name, version)
    %Q{gem.add_dependency(%q<#{gem_name}>, ["~> #{version}"])}  
  end


  def self.check_input(gem_name)
    if (gem_name.empty? || ['-h','--help','help'].include?(gem_name))
      $stderr.puts "Usage: gemline [GEM NAME]"
      $stderr.puts "  Prints a Gemfile require line for a Ruby gem on Rubygems.org"
      Kernel.exit 1
    end
    
    # if (['-v','--version'].include?(gem_name))
    #   puts "gemline #{Gemline::VERSION}"
    #   exit
    # end
  end

  def self.copy_to_clipboard(gemline)
    begin
      if clipboard = IO.popen('pbcopy', 'r+')
        clipboard.puts gemline
        $stderr.puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
      end
    rescue
      ## Yeah, I hate this too.  But it does what I want -- silently fail if pbcopy isn't available.
      ##   TODO: Use something more reliable and cross-platform.
    end
  end

end
