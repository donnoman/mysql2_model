require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mysql2_model"
    gem.summary = %Q{Provides connection management and evented async query model containers built around the Myqsl2 Gem}
    gem.description = %Q{Thin veneer to mysql2 to allow very precise, deliberate, performant containment of associated business logic that is expressed in direct MySQL statements}
    gem.email = "donnoman@donovanbray.com"
    gem.homepage = "http://github.com/donnoman/mysql2_model"
    gem.authors = ["donnoman"]
    gem.add_runtime_dependency "mysql2", "~> 0.2"
    gem.add_development_dependency "rspec", "~> 1.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mysql2_model2 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
