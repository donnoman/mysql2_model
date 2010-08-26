require 'rubygems'
require "active_support/core_ext/object/blank"

require 'mysql2'
require 'mysql2_model/client'
require 'mysql2_model/container'

# = Mysql2Model
#
#
module Mysql2Model
  VERSION = File.read(File.expand_path(File.dirname(__FILE__) + '/../VERSION')).strip
  
  #TODO: How to identify config/repositories when we don't know what framework they are using?
  #Depending on the user to explicitly set this and override the value.
  def self.respository_path
    @@repository_path ||= 'repositories.yml'
  end
  
  def self.repository_path=(path)
    @@repository_path = path
  end
end