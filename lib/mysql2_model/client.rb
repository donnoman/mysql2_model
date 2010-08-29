module Mysql2Model
  class Client
    #TODO: Create connection pooling infrastructure
    def self.repositories
      load_repos
      @@repositories
    end
    def self.load_repos(forced=false)
      return if defined?(@@repositories) unless forced
      repos = YAML.load(File.new(Mysql2Model::Config.repository_path, 'r'))
      repos[:repositories].each do |repo, config|
        self[repo] = config 
      end
    end
    def self.[](repository_name)
      load_repos
      @@repositories[repository_name][:client] ||= begin
        c = Mysql2::Client.new(@@repositories[repository_name][:config])
        c.query_options.merge!(:symbolize_keys => true)
        c
      end
    end
    def self.[]=(repository_name,config)
      @@repositories ||= {}
      @@repositories[repository_name] ||= {}
      @@repositories[repository_name][:config] = config
    end
  end
end