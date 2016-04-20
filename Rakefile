require 'bundler'
require 'bundler/gem_tasks'
require 'minitest/autorun'
require 'rake/extensiontask'
require 'rake/testtask'

# add compile tasks
Rake::ExtensionTask.new('harfbuzz')

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['./test/test_*.rb']
  t.verbose = true
end

desc 'Run benchmark'
task :benchmark do
  load './examples/benchmark.rb'
end