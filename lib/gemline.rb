require "net/https"
require "clipboard"
require "json"

require_relative "./gemline/rubygems"

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
    @json = Gemline::Rubygems.get_rubygem_json(@gem)
    unless gem_not_found?
      @response = JSON.parse(@json)
      @gemline = Gemline.create_gemline(@gem, response["version"], options)
    end
  end

  def sanitize_gem_name(gem_name)
    gem_name.to_s.gsub(/[^\w-]+/, "") # Yeah, a little over-defensive.
  end

  def gem_not_found?
    !!@json.match(/(could not be found|does not exist)/)
  end

  def self.options_to_string(options = {})
    if options[:group]
      options[:group] = [options[:group]].flatten.map(&:to_sym)
      options[:group] = options[:group].first if options[:group].length == 1
    end

    options.map { |k, v| "#{k}: #{value_to_string(v)}" }.join(", ")
  end

  def self.value_to_string(val)
    case val
    when Array
      val.to_s
    when Symbol
      ":#{val}"
    when String
      "\"#{val}\""
    end
  end

  def self.create_gemline(gem_name, version, options)
    if options[:gemspec]
      gemspec_gemline(gem_name, version, options)
    else
      gemfile_gemline(gem_name, version, options.delete_if { |k, _| k == :gemspec })
    end
  end

  def self.gemfile_gemline(gem_name, version, options)
    %Q{gem "#{gem_name}", "~> #{version}"#{gemfile_gemline_options_suffix(options)}}
  end

  def self.gemfile_gemline_options_suffix(options)
    !options.empty? ? ", " + options_to_string(options) : ""
  end

  def self.gemspec_gemline(gem_name, version, options)
    dependency_signifier = options[:group]&.include?('development') ? "add_development_dependency" : "add_dependency"
    %Q{gem.#{dependency_signifier} "#{gem_name}", "~> #{version}"}
  end

  def self.copy_to_clipboard(gemline)
    Clipboard.copy gemline
    $stderr.puts "  Gem line copied to your clipboard.  Ready to paste into your Gemfile"
  rescue
    ## Yeah, I hate this too.  But it does what I want -- silently fail if Clipboard fails.
  end
end
