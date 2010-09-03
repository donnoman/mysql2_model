module Mysql2Model
  # Configuration Attributes
  class Config
    private_class_method :new
    class << self
      attr_writer :repository_path
      # Location of the YAML file to define the repositories
      # @todo Identify a default repositories.yml inside the consuming projects' root.
      #   How to identify config/repositories.yml when we don't know what framework they are using?      
      def repository_path
        @repository_path ||= 'repositories.yml'
      end
    end
  end
end