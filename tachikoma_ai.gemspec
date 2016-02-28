# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tachikoma_ai/version'

Gem::Specification.new do |spec|
  spec.name          = "tachikoma_ai"
  spec.version       = TachikomaAi::VERSION
  spec.authors       = ["sinsoku"]
  spec.email         = ["sinsoku.listy@gmail.com"]

  spec.summary       = 'A tachikoma will get a artificial intelligence, and will become a high-spec combat vehicles.'
  spec.description   = 'Give a comparing function on GitHub to tachikoma'
  spec.homepage      = 'https://github.com/sinsoku/tachikoma_ai'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'tachikoma', '>= 4.2'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'rubocop'
end
