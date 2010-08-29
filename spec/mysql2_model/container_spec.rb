require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class M2MContainer
  include Mysql2Model::Container
  
  def self.default_repository_array
    [database,username,password,host]
  end
  
  def default_repository_array
    [database,username,password,host]
  end
end

describe M2MContainer do
  before :each do
     Mysql2Model::Config.should_receive(:repository_path).any_number_of_times.and_return(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml.fixture'))
     Mysql2Model::Client.load_repos(true)
  end
  describe "class" do
    it "should have direct access to the default_repository hash members" do
      M2MContainer.default_repository_array.should eql(['mysql2_model_test','root','gibberish','localhost'])
    end
  end
  describe "instance" do
    it "should have direct access to the default_repository hash members" do
      M2MContainer.new({}).default_repository_array.should eql(['mysql2_model_test','root','gibberish','localhost'])
    end
  end
end

describe M2MContainer, "mysql2 methods" do
  before :each do
    Mysql2Model::Config.should_receive(:repository_path).any_number_of_times.and_return(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml'))
    Mysql2Model::Client.load_repos(true) #fooling with the class repository path, need to make sure we don't use the fixture
  end
  describe "query" do
    it "should return an array with a member named 'test'" do
      M2MContainer.query("SELECT * FROM mysql2_model_test").first.name.should eql('test')
    end
  end
  
  describe "value" do
    it "should return only the first value of the first row" do
      M2MContainer.value("SELECT COUNT(*) FROM mysql2_model_test").should eql(1)
    end
  end
end
