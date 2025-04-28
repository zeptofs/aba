# frozen_string_literal: true

require_relative "lib/aba/version"

Gem::Specification.new do |spec|
  spec.name          = "aba"
  spec.version       = Aba::VERSION
  spec.authors       = ["Zepto Payments", "Andrey Bazhutkin", "Trevor Wistaff"]
  spec.email         = ["engineering@zepto.com.au", "andrey.bazhutkin@gmail.com"]
  spec.summary       = "ABA File Generator"
  spec.description   = "ABA (Australian Bankers Association) File Generator"
  spec.homepage      = "https://github.com/zeptofs/aba"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "rspec", "~> 3.0"
end
