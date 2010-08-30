module Mysql2Model
  class Client
    private_class_method :new
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
        load_repos
        @repositories[repository_name][:client] ||= begin
          c = Mysql2::Client.new(@repositories[repository_name][:config])
          c.query_options.merge!(:symbolize_keys => true)
          c
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