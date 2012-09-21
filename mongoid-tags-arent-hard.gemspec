# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/tags_arent_hard/version'

Gem::Specification.new do |gem|
  gem.name          = "mongoid-tags-arent-hard"
  gem.version       = Mongoid::Tags::Arent::Hard::VERSION
  gem.authors       = ["Mark Bates"]
  gem.email         = ["mark@markbates.com"]
  gem.description   = %q{A tagging gem for Mongoid 3 that doesn't actually suck.}
  gem.summary       = %q{A tagging gem for Mongoid 3 that doesn't actually suck.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("mongoid", ">=3.0.0")
end
