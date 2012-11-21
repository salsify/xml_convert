# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xml_convert/version'

Gem::Specification.new do |gem|
  gem.name          = "xml_convert"
  gem.version       = XmlConvert::VERSION
  gem.authors       = ["Jeremy Redburn"]
  gem.email         = ["jredburn@salsify.com"]
  gem.description   = %q{xml_convert provides utility methods for encoding and
                          decoding XML names.}
  gem.summary       = %q{xml_convert provides utility methods for encoding and
                          decoding XML names.}
  gem.homepage      = "https://github.com/socialceramics/xml_convert"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rake")
  gem.add_development_dependency("yard")
  gem.add_development_dependency("redcarpet")
  gem.add_development_dependency("rspec")
end
