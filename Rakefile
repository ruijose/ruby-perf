require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
  exec "pry -r ruby_perf -I ./lib"
end

task :bora do
  exec "gem install ./ruby_perf-0.1.0.gem"
end
