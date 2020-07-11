# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aba/version'

Gem::Specification.new do |spec|
  spec.name          = "aba"
  spec.version       = Aba::VERSION
  spec.authors       = ["Andrey Bazhutkin", "Trevor Wistaff"]
  spec.email         = ["andrey.bazhutkin@gmail.com", "trev@a07.com.au"]
  spec.summary       = "ABA File Generator"
  spec.description   = "ABA (Australian Bankers Association) File Generator"
  spec.homepage      = "https://github.com/andrba/aba"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.required_ruby_version = '>= 2.5.0'
end
