module Mysql2Model
  
  module Container
    
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    def initialize(row)
      @attributes = row || {}
    end
  
    def respond_to?(method)
      return true if @attributes.key?(method)
      super
    end

    def id
      @attributes[:id]
    end
  
    def method_missing(method, *args, &block)
      if @attributes.key?(method)
        @attributes[method]
      else
        super
      end
    end
    
    #member notation convenience methods
    def [](method)
      @attributes[method]
    end
    
    def []=(method,value)
      @attributes[method] = value
    end
    #end member notation convenience methods
  
    #datamapper resource convenience methods
    def attribute_get(method)
      @attributes[method]
    end

    def attribute_set(method,value)
      @attributes[method]=value
    end
    #end datamapper resource convenience methods
    
    module ClassMethods
      
      def default_repository_name
        :default
      end
      
      def client
        @client ||= Mysql2Model::Client[default_repository_name]
      end

      #This will get more diverse, but we are starting very basic.
      def query(value)
        client.query(value).map do |row|
          #TODO: MonkeyPatch Mysql2 to support loading the primitives directly into custom class :as => CustomClass, and remove this map
          #TODO: This is defeating Mysql2's lazy loading, but it's good for proof-of-concept
          self.new(row)
        end
      end
      alias_method :execute, :query #allow the user to choose whether they want the mysql2 DSL or activerecord DSL
      
    end
  end
end