# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drezyna/version'

Gem::Specification.new do |spec|
  spec.name          = "drezyna"
  spec.version       = Drezyna::VERSION
  spec.authors       = ["Zaiste"]
  spec.email         = ["oh@zaiste.net"]

  spec.summary       = %q{Rails application template by Nukomeet}
  spec.description   = %q{Rails application template by Nukomeet}
  spec.homepage      = "http://github.com/nukomeet/drezyna"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["drezyna"] 
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "railties", "~> 4.2.5"
end
