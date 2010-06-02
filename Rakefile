require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "alumina"
    gem.summary = %Q{Ruby parser for various chemistry-related file formats}
    gem.description = %Q{This gem parses HyperChem's .HIN files, PDB files, and in the future others, converting them to Ruby objects for easy manipulation}
    gem.email = "git@timothymorgan.info"
    gem.homepage = "http://github.com/RISCfuture/alumina"
    gem.authors = ["Tim Morgan"]
    gem.add_development_dependency "bacon", ">= 0"
    gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |spec|
    spec.libs << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |doc|
    doc.options << "-m" << "textile"
    doc.options << "--protected"
    doc.options << "-r" << "README.textile"
    doc.options << "-o" << "doc"
    doc.options << "--title" << "Alumina Documentation".inspect
    
    doc.files << "lib/**/*"
  end
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

task :doc => :yard
