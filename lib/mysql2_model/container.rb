module Mysql2Model
  
  module Container
    
    def self.included(base)
      base.extend Forwardable
      base.extend ClassMethods
      base.extend Mysql2Model::Composer
      #TODO: do we need the delegators in the instance... not sure.
      base.def_delegators :default_repository_config, :database, :username, :host, :password
      base.class_eval do 
        class << self
          extend Forwardable
          def_delegators :default_repository_config, :database, :username, :host, :password
        end
      end
    end
  
    def initialize(row)
      raise ArgumentError, "must be a hash" unless row.is_a?(Hash)
      @attributes = row
    end
    
    def default_repository_config
      self.class.default_repository_config
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
      
      def default_repository_config
        OpenStruct.new(Mysql2Model::Client.repositories[default_repository_name][:config])
      end
      
      def default_repository_name
        :default
      end
      
      def client
        Mysql2Model::Client[default_repository_name]
      end
      
      # Return only the first value from the first row.
      # Useful with queries that only return one result, like a COUNT.
      def value(statement='',*args)
        statement = yield if block_given?
        composed_sql = compose_sql(statement,*args).strip
        log.info("SQL:[#{composed_sql}]")
        client.query(composed_sql).first.first.last
      end

      # Return the resultset as instances of self instead of Mysql2::Result
      def query(statement='',*args)
        statement = yield if block_given?
        composed_sql = compose_sql(statement,*args).strip
        log.info("SQL:[#{composed_sql}]")
        response = client.query(composed_sql)
        if response.respond_to?(:map)
          response.map do |row|
            #TODO: MonkeyPatch Mysql2 to support loading the primitives directly into custom class :as => CustomClass, and remove this map
            #TODO: This is defeating Mysql2's lazy loading, but it's good for proof-of-concept
            self.new(row)
          end
        else
          response
        end
      end
      alias_method :execute, :query #allow the user to choose whether they want the mysql2 DSL or activerecord DSL
      
      def log
        Mysql2Model::LOGGER
      end
      
    end
  end
end