$:.push File.expand_path("../lib", __FILE__)
require "dfm/version"

Gem::Specification.new do |s|
  s.name        = 'dfm'
  s.version     = DFM::VERSION
  s.licenses    = ['The MIT License (MIT)']
  s.summary     = "Duplicate File Manager."
  s.description = "Duplicate File Manager.  Recursively index duplicate files!"
  s.authors     = ["Daniel P. Clark / 6ftDan(TM)"]
  s.email       = 'webmaster@6ftdan.com'
  s.files       = ['lib/dfm/version.rb', 'lib/dfm.rb', 'README.md', 'LICENSE', 'bin/dfm']
  s.homepage    = 'https://github.com/danielpclark/dfm'
  s.executables = ['dfm']
  s.platform    = 'ruby'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.1'
end