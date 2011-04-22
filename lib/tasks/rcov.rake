# Forked to get it working with Rails 3 and RSpec 2
#
# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data
#
# Use rcov:rspec or rcov:cucumber
# to get non-aggregated coverage reports for rspec or cucumber separately

require 'cucumber/rake/task'
require "rspec/core/rake_task"

namespace :rcov do
  Cucumber::Rake::Task.new(:cucumber_run) do |t|
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end

  RSpec::Core::RakeTask.new(:rspec_run) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
  end

  desc "Run both specs and features to generate aggregated coverage"
  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber_run"].invoke
    Rake::Task["rcov:rspec_run"].invoke
  end

  desc "Run only rspecs"
  task :rspec do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:rspec_run"].invoke
  end

  desc "Run only cucumber"
  task :cucumber do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber_run"].invoke
  end
end




#
# require 'cucumber/rake/task' #I have to add this
# require 'spec/rake/spec_task'
#
# namespace :rcov do
#   Cucumber::Rake::Task.new(:cucumber) do |t|
#     t.rcov = true
#     t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
#     t.rcov_opts << %[-o "coverage"]
#   end
#
#   Spec::Rake::SpecTask.new(:rspec) do |t|
#     t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
#     t.spec_files = FileList['spec/**/*_spec.rb']
#     t.rcov = true
#     t.rcov_opts = lambda do
#       IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
#     end
#   end
#
#   desc "Run both specs and features to generate aggregated coverage"
#   task :all do |t|
#     rm "coverage.data" if File.exist?("coverage.data")
#     Rake::Task["rcov:cucumber"].invoke
#     Rake::Task["rcov:rspec"].invoke
#   end
# end