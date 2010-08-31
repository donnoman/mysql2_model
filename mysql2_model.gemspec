# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql2_model}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["donnoman"]
  s.date = %q{2010-08-31}
  s.description = %q{Thin veneer to mysql2 to allow very precise, deliberate, performant containment of associated business logic that is expressed in direct MySQL statements}
  s.email = %q{donnoman@donovanbray.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG.md",
     "Gemfile",
     "Gemfile.lock",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/mtdb.rb",
     "examples/repositories.yml",
     "lib/mysql2_model.rb",
     "lib/mysql2_model/client.rb",
     "lib/mysql2_model/composer.rb",
     "lib/mysql2_model/config.rb",
     "lib/mysql2_model/container.rb",
     "mysql2_model.gemspec",
     "spec/mysql2_model/client_spec.rb",
     "spec/mysql2_model/composer_spec.rb",
     "spec/mysql2_model/config_spec.rb",
     "spec/mysql2_model/container_spec.rb",
     "spec/mysql2_model_spec.rb",
     "spec/repositories.yml.fixture",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/donnoman/mysql2_model}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Mysql2Model is a container for creating model code based on the Mysql2 gem}
  s.test_files = [
    "spec/mysql2_model/client_spec.rb",
     "spec/mysql2_model/container_spec.rb",
     "spec/mysql2_model/config_spec.rb",
     "spec/mysql2_model/composer_spec.rb",
     "spec/mysql2_model_spec.rb",
     "spec/spec_helper.rb",
     "examples/mtdb.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mysql2>, ["~> 0.2"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 2.3"])
      s.add_runtime_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_runtime_dependency(%q<logging>, ["~> 1"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<mysql2>, ["~> 0.2"])
      s.add_dependency(%q<activesupport>, ["~> 2.3"])
      s.add_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_dependency(%q<logging>, ["~> 1"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<mysql2>, ["~> 0.2"])
    s.add_dependency(%q<activesupport>, ["~> 2.3"])
    s.add_dependency(%q<builder>, ["~> 2.1.2"])
    s.add_dependency(%q<logging>, ["~> 1"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end

