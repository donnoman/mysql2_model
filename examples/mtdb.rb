require "mysql2_model"

Mysql2Model::Config.repository_path = File.expand_path(File.dirname(__FILE__) + '/../templates/repositories.yml')

# # Use like:
# Mtdb.all.each |mtdb|
#   puts "Database: #{mtdb.database_name}:" #direct method access
#   puts "Host: #{mtdb[:db_server_host]}"   #direct member access
#   puts "Config: {mtdb.to_config.inspect}" #model methods
# end

class Mtdb
  include Mysql2Model::Container
  
  def self.all
    query("SELECT id, database_name, db_server_host, db_server_port, db_server_user, db_server_password * FROM mtdbs")
  end
  
  def config_name
    "mtdb#{id}".to_sym
  end
  
  def to_config
    {
      config_name => {
        :host => db_server_host,
        :database => database_name,
        :port => db_server_port,
        :username => db_server_user,
        :password => db_server_password_unencrypted
      }
    }
  end
  
  def db_server_password_unencrypted
    nil # You have to invent your own.
  end
  
  def self.default_repository_name # You don't need this if you want to use the default repo
    :infrastructure
  end
  
end