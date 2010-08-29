require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class M2MComposer
  include Mysql2Model::Container
end

describe M2MComposer do
  describe "compose_sql" do
    context "string" do
      it "should return the string" do
        M2MComposer.compose_sql("one two three 4").should eql("one two three 4")
      end
    end
    context "array" do
      it "should assemble use multiple arguments as the array" do
        M2MComposer.compose_sql("%s %s %s %d",'one','two','three',4).should eql("one two three 4")
      end
      it "should support passing in an array" do
        M2MComposer.compose_sql(["one two three 4",'one','two','three',4]).should eql("one two three 4")
      end
      it "should support passing in an array and single string" do
        #or should this raise?
        M2MComposer.compose_sql(["one two three 4"]).should eql("one two three 4")
      end      
      it "should support printf style substitution" do
        M2MComposer.compose_sql("%s %s %s %d",'one','two','three',4).should eql("one two three 4")
      end
      it "should support ? placeholders" do 
        M2MComposer.compose_sql("? ? ? ?",'one','two','three',4).should eql("one two three 4")
      end
      it "should support named bind variables" do
        M2MComposer.compose_sql(":uno :dos :tres :cuatro :uno :dos :tres :cuatro",:uno => 'one', :dos => 'two',:tres => 'three', :cuatro => 4).should eql("one two three 4 one two three 4")
      end
      it "should raise an error with mismatched number of replacements" do
        lambda { M2MComposer.compose_sql("? ? ? ?",'one','two','three') }.should raise_error(Mysql2Model::PreparedStatementInvalid)
      end
    end
  end
  describe "query" do
    before :each do
      @client = Mysql2Model::Client[:default]
    end
    it "should be composed with a string" do
      @client.should_receive(:query).with("SELECT 1").and_return([])
      M2MComposer.query("SELECT 1")
    end
    it "should be composed with multiple arguments" do
      @client.should_receive(:query).with("one two three 4").and_return([])
      M2MComposer.query("%s %s %s %d",'one','two','three',4)
    end
    it "should be composed with an array" do
      @client.should_receive(:query).with("one two three 4").and_return([])
      M2MComposer.query(["%s %s %s %d",'one','two','three',4])
    end
    context "with a block" do
      it "should be composed when in an array" do
        @client.should_receive(:query).with("one two three 4").and_return([])
        M2MComposer.query do 
          ["%s %s %s %d",'one','two','three',4]
        end
      end
      it "should be composed when a string" do
        @client.should_receive(:query).with("one two three 4").and_return([])
        M2MComposer.query do 
          "one two three 4"
        end
      end
    end
  end
  describe "value" do
    before :each do
      @client = Mysql2Model::Client[:default]
    end
    it "should be composed with a string" do
      @client.should_receive(:query).with("SELECT 1").and_return([])
      M2MComposer.query("SELECT 1")
    end
    it "should be composed with multiple arguments" do
      @client.should_receive(:query).with("one two three 4").and_return([])
      M2MComposer.query("%s %s %s %d",'one','two','three',4)
    end
    it "should be composed with an array" do
      @client.should_receive(:query).with("one two three 4").and_return([])
      M2MComposer.query(["%s %s %s %d",'one','two','three',4])
    end
    context "with a block" do
      it "should be composed when in an array" do
        @client.should_receive(:query).with("one two three 4").and_return([])
        M2MComposer.query do 
          ["%s %s %s %d",'one','two','three',4]
        end
      end
      it "should be composed when a string" do
        @client.should_receive(:query).with("one two three 4").and_return([])
        M2MComposer.query do 
          "one two three 4"
        end
      end
    end
  end  
end