# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave_reupload_fix/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave_reupload_fix"
  spec.version       = CarrierwaveReuploadFix::VERSION
  spec.authors       = ["Azdaroth"]
  spec.email         = ["azdaroth@gmail.com"]
  spec.description   = %q{Extension for fixing processing images with carrierwave on reupload
                          when file extension changes}
  spec.summary       = %q{Extension for fixing processing images with carrierwave}
  spec.homepage      = "https://github.com/Azdaroth/carrierwave_reupload_fix"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "carrierwave"
  spec.add_dependency("rails", [">= 3.0"])

end
