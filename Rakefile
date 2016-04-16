require 'bundler'
Bundler.require
require 'bundler/gem_tasks'

require 'minitest/autorun'

desc 'Run tests.'
task :test do
  Dir.glob('./test/test_*.rb').each { |file| require file}
end

desc 'Run benchmark.'
task :benchmark do
  load './examples/benchmark.rb'
end