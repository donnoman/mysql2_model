require 'rubygems'
require "active_support/core_ext/object/blank"
# require "active_support/core_ext"
require 'mysql2'
require 'forwardable'

# = Mysql2Model
#
#
module Mysql2Model
  VERSION = File.read(File.expand_path(File.dirname(__FILE__) + '/../VERSION')).strip
end

require 'mysql2_model/config'
require 'mysql2_model/client'
require 'mysql2_model/container'
require 'mysql2_model/composer'