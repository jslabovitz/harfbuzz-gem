require 'bundler/gem_tasks'
Bundler.require
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test_*.rb']
end

task :default => :test