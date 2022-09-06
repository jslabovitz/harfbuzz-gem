Gem::Specification.new do |s|
  s.name          = 'harfbuzz'
  s.version       = '0.4'
  s.summary       = 'Ruby interface to the Harfbuzz text shaping engine'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    Harfbuzz is a Ruby interface to the Harfbuzz text shaping engine.
  }
  s.license       = 'MIT'
  s.homepage      = 'http://github.com/jslabovitz/harfbuzz-gem'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'ffi', '~> 1.15'

  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'minitest', '~> 5.16'
  s.add_development_dependency 'minitest-power_assert', '~> 0.3'
end