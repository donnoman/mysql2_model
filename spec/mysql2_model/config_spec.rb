require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mysql2Model::Config do
  describe "repository_path" do
    it "should have a default" do
      Mysql2Model::Config.repository_path.should eql('repositories.yml')
    end
    it "should be muteable" do
      Mysql2Model::Config.repository_path = 'databases.yml'
      Mysql2Model::Config.repository_path.should eql('databases.yml')
    end
  end
end