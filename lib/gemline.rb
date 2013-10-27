require 'json/pure'
require 'net/https'
require 'clipboard'

class Gemline
  attr_accessor :gem, :gemline, :json, :response

  def self.query(gem_name, options = {})
    g = Gemline.new(gem_name, options)

    if g.gem_not_found?
      $stderr.puts "Ruby gem #{gem_name} was not found on rubygems.org"
      Kernel.exit 1
    else
      puts g.gemline
      copy_to_clipboard(g.gemline)
    end
  end

  def initialize(gem_name, options = {})
    @gem = sanitize_gem_name(gem_name)
    @json = Gemline.get_rubygem_json(@gem)
    unless gem_not_found?
      @response = JSON.parse(@json)
      @gemline = Gemline.create_gemline(@gem, response['version'], options)
    end
  end

  def sanitize_gem_name(gem_name)
    gem_name.to_s.gsub(/[^\w\-]+/,'') # Yeah, a little over-defensive.
  end

  def gem_not_found?
    @json.match(/(could not be found|does not exist)/)
  end


  private

  def self.get_rubygem_json(gem_name)
    uri = URI.parse("https://rubygems.org/api/v1/gems/#{gem_name}.json")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.body
  end

  def self.create_gemline(gem_name, version, options)
    if options[:gemspec]
      return gemspec_gemline(gem_name, version, options)
    else
      return gemfile_gemline(gem_name, version, options.delete_if {|k,v| k == :gemspec})
    end
  end

  def self.gemfile_gemline(gem_name, version, options)
    options_string = options.empty? ? '' : ', '
    options_string << options.inspect.delete('{}').gsub(/(?!\s)=>(?!\s)/, ' => ')

    %Q{gem "#{gem_name}", "~> #{version}"#{options_string}}
  end

  def self.gemspec_gemline(gem_name, version, options)
    if options[:group] == :development
      %Q{gem.add_development_dependency "#{gem_name}", ">= #{version}"}
    else
      %Q{gem.add_dependency "#{gem_name}", ">= #{version}"}
    end
  end

  def self.copy_to_clipboard(gemline)
    begin
      Clipboard.copy gemline
      $stderr.puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
    rescue
      ## Yeah, I hate this too.  But it does what I want -- silently fail if Clipboard fails.
    end
  end

end
