module Mysql2Model
  
  # Generic Mysql2Model exception class.
  class Mysql2ModelError < StandardError
  end
  
  # Raised when number of bind variables in statement does not match number of expected variables.
  # @example two placeholders are given but only one variable to fill them.
  #   query("SELECT FROM locs WHERE lat = ? AND lng = ?", 53.7362)
  class PreparedStatementInvalid < Mysql2ModelError
  end
  
  # Adapted from Rails ActiveRecord::Base
  #
  # Changed the language from "Sanitize", since not much sanitization is going on here.
  # There is some escaping and coercion going on, but nothing explicity santizes the resulting statement.
  module Composer
    
    # Accepts multiple arguments, an array, or string of SQL and composes them
    # @example String
    #   "name='foo''bar' and group_id='4'" #=>  "name='foo''bar' and group_id='4'"
    # @example Array
    #   ["name='%s' and group_id='%s'", "foo'bar", 4]  #=>  "name='foo''bar' and group_id='4'"
    # @param [Array,String]
    def compose_sql(*statement)
      raise PreparedStatementInvalid, "Statement is blank!" if statement.blank?
      if statement.is_a?(Array)
        if statement.size == 1 #strip the outer array
          compose_sql_array(statement.first)
        else
          compose_sql_array(statement)
        end
      else
        statement
      end
    end
    
    # Accepts an array of conditions.  The array has each value
    # sanitized and interpolated into the SQL statement.
    # @param [Array] ary
    # @example Array
    #   ["name='%s' and group_id='%s'", "foo'bar", 4]  #=>  "name='foo''bar' and group_id='4'"
    # @private
    def compose_sql_array(ary)
      statement, *values = ary
      if values.first.is_a?(Hash) and statement =~ /:\w+/
        replace_named_bind_variables(statement, values.first)
      elsif statement.include?('?')
        replace_bind_variables(statement, values)
      else
        statement % values.collect { |value| client.escape(value.to_s) }
      end
    end

    def replace_bind_variables(statement, values) # @private
      raise_if_bind_arity_mismatch(statement, statement.count('?'), values.size)
      bound = values.dup
      statement.gsub('?') { escape_bound_value(bound.shift) }
    end

    def replace_named_bind_variables(statement, bind_vars) # @private
      statement.gsub(/(:?):([a-zA-Z]\w*)/) do
        if $1 == ':' # skip postgresql casts
          $& # return the whole match
        elsif bind_vars.include?(match = $2.to_sym)
          escape_bound_value(bind_vars[match])
        else
          raise PreparedStatementInvalid, "missing value for :#{match} in #{statement}"
        end
      end
    end


    def escape_bound_value(value) # @private
      if value.respond_to?(:map) && !value.is_a?(String)
        if value.respond_to?(:empty?) && value.empty?
          escape(nil)
        else
          value.map { |v| escape(v) }.join(',')
        end
      else
        escape(value)
      end
    end

    def raise_if_bind_arity_mismatch(statement, expected, provided) # @private
      unless expected == provided
        raise PreparedStatementInvalid, "wrong number of bind variables (#{provided} for #{expected}) in: #{statement}"
      end
    end
    
    def escape(value) # @private
      client.escape(convert(value))
    end
    
    # Attempt to coerce the value to be a representation consistent with the database
    # @private
    def convert(value) 
      return value.to_formatted_s(:db) if value.respond_to?(:to_formatted_s)
      value.to_s
    end
    
  end

end
