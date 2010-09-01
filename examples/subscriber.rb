require "mysql2_model"

Mysql2Model::Config.repository_path = File.expand_path(File.dirname(__FILE__) + '/../examples/repositories.yml')

class Subscriber
  
  include Mysql2Model::Container
  
  # Assume :subscribers1 has 200 rows, :subscriber2 has 150, :subscriber3 has 50.
  
  def self.all
    query("SELECT * FROM subscribers") # => resultset of 400 rows
  end
  
  def self.count
    value_sum("SELECT COUNT(*) FROM subscribers") # => 400
  end
  
  def self.count_from_each
    value("SELECT COUNT(*) FROM subscribers") # => [200,150,50]
  end
  
  def self.default_repository_name
    [:subscribers1,:subscribers2,:subscribers3]
  end
  
end