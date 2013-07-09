require "bundler/gem_tasks"
require 'rake'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Run tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

task :default => [:spec]
