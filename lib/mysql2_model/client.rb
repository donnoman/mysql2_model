module Mysql2Model
  # multi-repository aware mysql2 client proxy
  # @todo Evented Connection Pool
  class Client
    # @return a multi-repository proxy
    def initialize(repos)
      @repos = repos
    end
    # Collect the results of a multi-repository query into a single resultset
    # @param [String] statement MySQL statement
    def query(statement)
      collection = []
      @repos.each do |repo|
        self.class[repo].query(statement).each do |row| 
          collection << row
        end
      end
      collection
    end
    # Use the first connection to execute a single escape
    # @param [String] statement MySQL statement
    def escape(statement)
      self.class[@repos.first].escape(statement)
    end
    
    class << self
      # Stores a collection of mysql2 connections 
      def repositories
        load_repos
        @repositories 
      end
      # loads the repositories with the YAML object pointed to by {Mysql2Model::Config.repository_path},
      # subsequent calls are ignored unless forced.
      # @param [boolean] force Use force = true to reload the repositories and overwrite the existing Hash.
      def load_repos(force=false)
        unless force
          return unless @repositories.blank?
        end
        repos = YAML.load(File.new(Mysql2Model::Config.repository_path, 'r'))
        repos[:repositories].each do |repo, config|
          self[repo] = config 
        end
      end
      # Repository accessor lazily instantiates Mysql2::Clients or delegates them to an instance of the multi-repository proxy
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
      # Repository accessor stores the connection parameters for later use
      def []=(repository_name,config)
        @repositories ||= {}
        @repositories[repository_name] ||= {}
        @repositories[repository_name][:config] = config
      end
    end
    
  end
end