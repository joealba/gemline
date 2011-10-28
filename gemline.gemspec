# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gemline/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joseph Alba"]
  gem.email         = ["joe@joealba.com"]
  gem.description   = %q{Grab the latest Gemfile 'gem' line for a specific Ruby gem}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "gemline"
  gem.require_paths = ["lib"]
  gem.version       = Gemline::VERSION

	gem.add_dependency('thor')
	gem.add_dependency('crack')
#  gem.add_development_dependency(%q<rspec>, [">= 2.7.0"])

end
