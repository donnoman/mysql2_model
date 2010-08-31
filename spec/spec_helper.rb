$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mysql2_model'
require 'spec'
require 'spec/autorun'
require 'ruby-debug'

Spec::Runner.configure do |config|
  config.before(:all) do
    Mysql2Model::Config.repository_path = File.join(File.dirname(__FILE__), 'repositories.yml')
    Mysql2Model::LOGGER.level = :fatal
    client = Mysql2::Client.new(YAML.load(File.read(Mysql2Model::Config.repository_path))[:repositories][:default])
    client.query %[ DROP TABLE IF EXISTS mysql2_model_test ]
    client.query %[
      CREATE TABLE IF NOT EXISTS mysql2_model_test (
        id MEDIUMINT NOT NULL AUTO_INCREMENT,
        name VARCHAR(40),
        value VARCHAR(40),
        created_at DATETIME,
        updated_at DATETIME,
        PRIMARY KEY (id)
      )
    ]
    client.query %[
      INSERT INTO mysql2_model_test (
        name, value, updated_at, created_at
      )

      VALUES (
        'test', 'garbage', NOW(), NOW()
      )
    ]
  end
end
