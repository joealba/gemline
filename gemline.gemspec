# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Joe Alba"]
  gem.email         = ["joe@joealba.com"]
  gem.description   = %q{Grab the latest Gemfile 'gem' line for a specific Ruby gem}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/joealba/gemline"

  gem.executables   = ['gemline']
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "gemline"
  gem.require_paths = ["lib"]

  gem.version       = '0.4.5'
  gem.license       = 'MIT'

  gem.add_dependency "clipboard", ">= 1.3.5"

  # if RUBY_PLATFORM =~ /(win|w)32$/
    ## The clipboard gem doesn't do a platform-dependent check,
    ##  and the gem will not work on Windows without ffi.
    gem.add_dependency "ffi"
  # end

	gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 3.0"
  gem.add_development_dependency "simplecov"
end
