# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'item_checkout/version'

Gem::Specification.new do |spec|
  spec.name          = "item_checkout"
  spec.version       = ItemCheckout::VERSION
  spec.authors       = ["Tomas Varneckas"]
  spec.email         = ["t.varneckas@gmail.com"]
  spec.description   = %q{This gem implements a simple item checkout system. Custom discounts can be added to it.}
  spec.summary       = %q{A simple item checkout system.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13"
end
