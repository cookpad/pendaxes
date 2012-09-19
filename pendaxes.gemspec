# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pendaxes/version'

Gem::Specification.new do |gem|
  gem.name          = "pendaxes"
  gem.version       = Pendaxes::VERSION
  gem.authors       = ["Shota Fukumori (sora_h)"]
  gem.email         = ["sorah@cookpad.com"]
  gem.description   = %q{Throw axes to pending makers!}
  gem.summary       = <<-EOS
Throw axes to pending makers! Leaving a pending long time is really bad,
shouldn't be happened.
So, this gem sends notification to committer that added pending after a while from the commit.

Avoid the trouble due to pending examples :D
  EOS
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'hashr'
  gem.add_dependency 'haml'
  gem.add_dependency 'mail'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
