module Mysql2Model
  
  # include this module in your class to inherit all of this awsomeness
  # @example
  #   class MyClass
  #     include Mysql2Model::Container
  #   end
  module Container
    
    def self.included(base)
      base.extend Forwardable
      base.extend ClassMethods
      base.extend Mysql2Model::Composer
      #@TODO Do we need the delegators in the instance? ...not sure.
      base.def_delegators :default_repository_config, :database, :username, :host, :password
      base.class_eval do 
        class << self
          extend Forwardable
          def_delegators :default_repository_config, :database, :username, :host, :password
        end
      end
    end
    
    # @raise [ArgumentError] Row must be a Hash
    # @param [Hash] row Expects a row from a Mysql2 resultset
    def initialize(row)
      raise ArgumentError, "must be a hash" unless row.is_a?(Hash)
      @attributes = row
    end
    
    def default_repository_config # @private
      self.class.default_repository_config
    end
  
    def respond_to?(method) # @private
      return true if @attributes.key?(method)
      super
    end

    # Delegate the id to the attribute :id insted of the Object_id
    def id
      @attributes[:id]
    end
  
    # Provide dynamic accessors to the internal attributes only
    def method_missing(method, *args, &block)
      if @attributes.key?(method)
        @attributes[method]
      else
        super
      end
    end
    
    #member notation convenience method
    def [](method)
      @attributes[method]
    end
    #member notation convenience method
    def []=(method,value)
      @attributes[method] = value
    end
  
    #datamapper style resource convenience method
    def attribute_get(method)
      @attributes[method]
    end
    
    #datamapper style resource convenience method
    def attribute_set(method,value)
      @attributes[method]=value
    end
    
    module ClassMethods
      
      def default_repository_config # @private
        OpenStruct.new(Mysql2Model::Client.repositories[default_repository_name][:config])
      end
      
      # Define which repository or repositories act as the destination(s) of your model.
      # @example Single Repository
      #   class MyClass
      #     include Mysql2Model::Container
      #     self.default_repository_name
      #       :infrastructure
      #     end
      #   end
      # @example Multiple Repositories
      #   class MyClass
      #     include Mysql2Model::Container
      #     self.default_repository_name
      #       [:db1,:db2,:db3]
      #     end
      #   end
      # @todo Should probably rename this to just default_repository since Array != Symbol or just "repository"; "default_repository_name" came from Datamapper
      # @abstract
      def default_repository_name
        :default
      end
      
      # Your models repository client via the cache
      def client
        Mysql2Model::Client[default_repository_name]
      end

      # @param [String] statement Uncomposed MySQL Statement
      # @param [Array] args arguements for composure
      # @yieldparam [String] composed_sql Composed MySQL Statement
      # @yieldreturn the return of the block
      def with_composed_sql(statement='',*args)
        composed_sql = compose_sql(statement,*args).strip
        log.info("SQL:[#{composed_sql}]")
        yield composed_sql
      end
      
      # @return the sum of adding the first value from each of the rows
      #   primarily useful with count queries running against multiple repos
      # @todo considering renaming value_sum => value, value => value_for_each, but what happens if value is a String instead of Numeric?
      # @todo Remove the block pattern, we will need to utilize the block for the evented query pattern
      def value_sum(statement='',*args)
        statement = yield if block_given?
        with_composed_sql(statement,*args) do |sql|
          client.query(sql).inject(0) { |sum,row|
            sum += row.first.last
          }
        end
      end
      
      # Useful with queries that only return one result, like a COUNT.
      # @return [Object] only the first value from the row when there is only one row
      # @return [Array] that contains the first value from each row if multiple rows are returned; as in a COUNT against multiple repos
      # @todo Remove the block pattern, we will need to utilize the block for the evented query pattern
      def value(statement='',*args)
        statement = yield if block_given?
        with_composed_sql(statement,*args) do |composed_sql|
          if (rv = client.query(composed_sql)).count > 1
            rv.map {|row| row.first.last }
          else
            rv.first.first.last
          end
        end
      end

      # Flavor the behavior by returning the resultset as instances of self instead of Mysql2::Result
      def query(statement='',*args)
        statement = yield if block_given?
        with_composed_sql(statement,*args) do |composed_sql|
          response = client.query(composed_sql)
          if response.respond_to?(:map)
            response.map do |row|
              # @todo Patch Mysql2 to support loading the primitives directly into custom class :as => CustomClass, and remove this map
              # @todo This is defeating Mysql2's lazy loading, but it's good for proof-of-concept
              self.new(row)
            end
          else
            response
          end
        end
      end
      alias_method :execute, :query #allow the user to choose whether they want the mysql2 DSL or activerecord DSL
      
      def log # @private
        Mysql2Model::LOGGER
      end
      
    end
  end
end