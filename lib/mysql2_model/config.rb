module Mysql2Model
  class Config
    #TODO: How to identify config/repositories when we don't know what framework they are using?
    #Depending on the user to explicitly set this and override the value.
    def self.repository_path
      @@repository_path ||= 'repositories.yml'
    end
  
    def self.repository_path=(path)
      @@repository_path = path
    end
  end
end