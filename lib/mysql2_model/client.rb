module Mysql2Model
  class Client
    def initialize(repos)
      @repos = repos
    end
    def query(statement)
      collection = []
      @repos.each do |repo|
        self.class[repo].query(statement).each do |row| 
          collection << row
        end
      end
      collection
    end
    def escape(statement)
      self.class[@repos.first].escape(statement)
    end
    
    class << self
      #TODO: Create connection pooling infrastructure
      def repositories
        load_repos
        @repositories 
      end
      def load_repos(force=false)
        unless force
          return unless @repositories.blank?
        end
        repos = YAML.load(File.new(Mysql2Model::Config.repository_path, 'r'))
        repos[:repositories].each do |repo, config|
          self[repo] = config 
        end
      end
      def [](repository_name)
        if repository_name.is_a?(Array)
          self.new(repository_name)
        else
          load_repos
          @repositories[repository_name][:client] ||= begin
            c = Mysql2::Client.new(@repositories[repository_name][:config])
            c.query_options.merge!(:symbolize_keys => true)
            c
          end
        end
      end
      def []=(repository_name,config)
        @repositories ||= {}
        @repositories[repository_name] ||= {}
        @repositories[repository_name][:config] = config
      end
    end
    
  end
end