module Mysql2Model
  class Config
    #TODO: How to identify config/repositories when we don't know what framework they are using?
    #Depending on the user to explicitly set this and override the value.
    
    private_class_method :new
    
    class << self
      attr_writer :repository_path
      def repository_path
        @repository_path ||= 'repositories.yml'
      end
    end
    
  end
end