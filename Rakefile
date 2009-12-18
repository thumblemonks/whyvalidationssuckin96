require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "whyvalidationssuckin96"
    gem.summary = %Q{An alternative implementation of object validations.}
    gem.description = %Q{A library for setting up model validations, such as in ActiveRecord.}
    gem.email = "gabriel.gironda@gmail.com"
    gem.homepage = "http://github.com/thumblemonks/whyvalidationssuckin96"
    gem.authors = ["gabrielg", "douglasmeyer"]
    gem.add_development_dependency "riot", ">= 0"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "activerecord", ">= 2.3.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test => :check_dependencies
task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
