# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickr_airlift/version'

Gem::Specification.new do |gem|
  gem.name          = "flickr_airlift"
  gem.version       = FlickrAirlift::VERSION
  gem.authors       = ["nodanaonlyzuul"]
  gem.email         = ["beholdthepanda@gmail.com"]
  gem.license       = 'MIT'
  gem.description   = "A Command-Line tool for scraping any user's original photos OR uploading all photos from a given directory"
  gem.summary       = "A Command-Line tool for scraping any user's original photos OR uploading all photos from a given directory"
  gem.homepage      = "https://github.com/nodanaonlyzuul/flickr_airlift"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'highline',              '1.6.11'
  gem.add_dependency 'flickr_authentication', '0.0.2'

  gem.rubyforge_project = 'nowarning'

end
