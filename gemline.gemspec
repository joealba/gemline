# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Joseph Alba"]
  gem.email         = ["joe@joealba.com"]
  gem.description   = %q{Grab the latest Gemfile 'gem' line for a specific Ruby gem}
  gem.summary       = %q{}
  gem.homepage      = "http://github.com/joealba/gemline"

  gem.executables   = ['gemline']
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "gemline"
  gem.require_paths = ["lib"]

  gem.version       = '0.1.3'

	gem.add_dependency('crack')
	gem.add_development_dependency('rake') # For Travis CI
  gem.add_development_dependency(%q<rspec>, [">= 2.7.0"])
end
