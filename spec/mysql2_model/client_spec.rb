require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mysql2Model::Client do
  describe "repositories" do
    it "should have repositories" do
      Mysql2Model::Client.repositories[:default].should_not be_nil
    end
  end
  describe "getting repositories" do
    it "should have a :default repository that is a 'Mysql2::Client'" do
      Mysql2Model::Client[:default].class.name.should eql("Mysql2::Client")
    end
  end
  describe "setting repositories" do
    it "should add the :mtdb1 repository" do
      Mysql2Model::Client[:mtdb1] = YAML.load(File.read(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml')))[:repositories][:default]
      Mysql2Model::Client[:mtdb1].class.name.should eql("Mysql2::Client")
    end
  end
  describe "load_repos" do
    context "forced" do
      it "should load_repos subsequent times" do
        rv = YAML.load(File.new(Mysql2Model::Config.repository_path, 'r'))
        YAML.should_receive(:load).twice.and_return(rv)
        2.times do
          Mysql2Model::Client.load_repos(true)
        end
      end
    end
    context "not forced" do
      it "should not load_repos again" do
        YAML.should_not_receive(:load)
        Mysql2Model::Client.load_repos
      end
    end
  end
end

class M2MClient
  include Mysql2Model::Container
  def self.all
    query("SELECT * FROM mysql2_model_test")
  end
end

describe M2MClient do
  describe "default_repository_name" do
    before :each do
      Mysql2Model::Config.should_receive(:repository_path).any_number_of_times.and_return(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml'))
      Mysql2Model::Client.load_repos(true)
    end
    describe "with multiple repositories" do
      before :each do 
        Mysql2Model::Client[:default2] = YAML.load(File.read(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml')))[:repositories][:default]
        Mysql2Model::Client[:default3] = YAML.load(File.read(File.expand_path(File.dirname(__FILE__) + '/../repositories.yml')))[:repositories][:default]      
        M2MClient.stub!(:default_repository_name).and_return([:default,:default2,:default3])
      end
      it "should return single resultset of merged rows" do
        M2MClient.all.size.should eql(6)
      end
      it "should add the values returned" do
        M2MClient.value_sum("SELECT COUNT(*) from mysql2_model_test").should eql(6)
      end
      it "should return an array of values" do
        M2MClient.value("SELECT COUNT(*) from mysql2_model_test").should eql([2,2,2])
      end
    end
    describe "with single repository" do
      before :each do 
        M2MClient.stub!(:default_repository_name).and_return(:default)
      end
      it "should return single resultset" do
        M2MClient.all.size.should eql(2)
      end
      it "should add the values returned" do
        M2MClient.value_sum("SELECT COUNT(*) from mysql2_model_test").should eql(2)
      end
      it "should return the value" do
        M2MClient.value("SELECT COUNT(*) from mysql2_model_test").should eql(2)
      end
    end
  end
end

