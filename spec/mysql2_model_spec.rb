require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Mysql2Model" do
  it "should report the same version as in the VERSION file" do
    Mysql2Model::VERSION.to_s.should == IO.read(File.expand_path(File.dirname(__FILE__) + "/../VERSION")).strip
  end
end
