#encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'harfbuzz/version'

Gem::Specification.new do |s|
  s.name          = 'harfbuzz'
  s.version       = Harfbuzz::VERSION
  s.summary       = 'Ruby interface to the Harfbuzz text shaping engine'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    Harfbuzz is a Ruby interface to the Harfbuzz text shaping engine.
  }
  s.homepage      = 'http://github.com/jslabovitz/harfbuzz-gem'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'ffi'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
end