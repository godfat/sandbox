
require 'sequel'

module Something
  # http://sequel.rubyforge.org/rdoc/files/doc/opening_databases_rdoc.html
  DATABASE_CONFIG = if ENV['DATABASE_URL']
    config = "#{ENV['DATABASE_URL']}?max_connections=#{ENV['DB_POOL']}"
    if RUBY_ENGINE == 'jruby'
      "jdbc:#{config}"
    else
      config
    end
  else
    require 'yaml'
    require 'erb'
    config = YAML.load(
      ERB.new(File.read("#{ROOT}/config/database.yaml")).result(binding))
    if RUBY_ENGINE == 'jruby'
      "jdbc:postgresql://#{config['host']}/#{config['database']}" \
      "?user=#{config['user']}&password=#{config['password']}"
    else
      config
    end
  end

  module I
    extend Sequel::Inflections
    singleton_class.send(:public, :singularize)

    def self.pluralize s, n=2
      if n == 1
        s
      else
        super s
      end
    end
  end

  Sequel.default_timezone = :utc # or it would default to local time
  Sequel.extension :pg_json, :pg_json_ops, :pg_array, :pg_array_ops

  Model = Class.new(Sequel::Model)
  Model.db = Sequel.connect(DATABASE_CONFIG, :after_connect =>
               lambda{ |c|
                 c.execute("SET LC_MONETARY TO 'POSIX'")
                 c.execute("SET statement_timeout TO 32500")
               })
  class Model
    include Something
    db.extension :pg_array

    def save!
      save(:raise_on_failure => true)
    end

    def save opts={}
      super({:changed => true}.merge(opts))
    end

    plugin :timestamps, :update_on_create => true
    plugin :instance_hooks
    plugin :table_select
    plugin :validation_helpers
    plugin :many_through_many

    include ToAPI
    def defined_associations
      self.class.associations
    end

    singleton_class.module_eval do
      def transaction *args, &block
        db.transaction(*args, &block)
      end
    end

    dataset_module do
      def sum *args
        super || 0
      end

      # User.one_to_one(:auth)
      # User.eager_cursor(1000, :auth) do |user|
      #   user.auth # no additional query
      # end
      def eager_cursor rows_per_fetch=1000, *associations
        cursor = use_cursor(rows_per_fetch: rows_per_fetch)
        cursor.each_slice(rows_per_fetch) do |records|
          associations.each do |assoc|
            refl = model.association_reflection(assoc)
            case refl[:type]
            when :one_to_one
              EagerCursorOneToMany
            when :many_to_one
              EagerCursorManyToOne
            else
              raise "Cannot handle: #{refl[:type]}"
            end.new(records, refl).load
          end

          records.each do |r|
            yield(r)
          end
        end
      end

      class EagerCursor < Struct.new(:records, :reflection)
        def load
          associations = reflection.associated_class.
            where(association_key => records.map(&record_key).uniq).all

          records.each do |r|
            a = associations.find(&method(:find).curry[r])
            r.associations[reflection[:name]] = a if a
          end

          records
        end

        private
        def find record, association
          record.public_send(record_key) ==
            association.public_send(association_key)
        end
      end

      class EagerCursorOneToMany < EagerCursor
        private
        def association_key; reflection[:key]      ; end
        def record_key     ; reflection.primary_key; end
      end

      class EagerCursorManyToOne < EagerCursor
        private
        def association_key; reflection.primary_key; end
        def record_key     ; reflection[:key]      ; end
      end
    end

    def == rhs
      self.class == rhs.class && id == rhs.id
    end

    def <=> rhs
      if self.class == rhs.class
        id <=> rhs.id
      else
        nil
      end
    end

    def update_column column, value
      data = if value.is_a?(Hash) then Sequel.pg_jsonb(value) else value end
      result = this.returning(column).update(column => data).first[column]
      public_send("#{column}=", result)
    end

    def update_columns attributes
      attributes.each do |key, value|
        update_column(key, value)
      end
    end

    def duplicate
      v = values.dup
      v.delete(:id)
      self.class.new(v)
    end

    def validates_numerical_attr_greater_than attr, value
      return unless send(attr)
      unless send(attr).is_a?(Numeric) && send(attr) > 0
        errors.add(attr, "#{attr} must be a numeric greater than #{value}")
      end
    end

    def self.set_single_table_inheritance
      plugin :single_table_inheritance, :type,
        :model_map => lambda{ |name|  "Something::#{name}" },
        :key_map   => :type_name.to_proc
    end

    def self.type_name
      name.sub(/^[^:]+::/, '')
    end

    # store_accessor for sequel
    def self.store_accessor column, keys=[]
      const_get(:Extension).module_eval(keys.map{ |k|
        <<-RUBY
          def #{k}
            #{column}[#{k.inspect}]
          end
          def #{k}= v
            #{column}[#{k.inspect}] = v
            modified!(:#{column})
            v
          end
        RUBY
      }.join("\n") +
      <<-RUBY, __FILE__, __LINE__ - 8 * keys.size - 2)
        def #{column}
          super || self.#{column} = Sequel.pg_jsonb({})
        end unless method_defined?(:#{column})
      RUBY
    end

    # strip NT$, in the money columns
    def self.money_accessor *columns
      const_get(:Extension).module_eval(columns.map{ |c|
        <<-RUBY
          def #{c}
            if r = super
              r.money
            end
          end
        RUBY
      }.join("\n"), __FILE__, __LINE__ - 4)
    end

    def self.relation_writer *relations
      const_get(:Extension).module_eval(relations.map{ |r|
        <<-RUBY
          def #{r}= v
            if new?
              after_save_hook{ replace_#{r}(v) }
            else
              replace_#{r}(v)
            end
          end

          private def replace_#{r} v
            (#{r}.subtract(v)).each do |vv|
              remove_#{I.singularize(r.to_s)}(vv)
            end

            (v.subtract(#{r})).each do |vv|
              add_#{I.singularize(r.to_s)}(vv)
            end

            associations.delete(:#{r}) # clear cache
          end
        RUBY
      }.join("\n"), __FILE__, __LINE__ - 18)
    end

    def self.with_connection &block
      db.pool.hold(&block)
    end

    def self.refresh
      db.run("REFRESH MATERIALIZED VIEW #{table_name}")
    end

    # sequel cannot deduce the full name, we need to specify
    def self.class_name name
      "Something::#{name}"
    end

    # get the database name
    def self.database d=db
      d.opts[:database]
    end

    def self.inherited subclass
      super # must call super first or it won't be setup correctly
      subclass.include(subclass.const_set(:Extension, Module.new))
    end

    def self.migrate
      Sequel.extension(:migration)
      out = "#{Something::ROOT}/migrations"
      Sequel::Migrator.run(db, out, :use_transactions => true)
    end

    def self.schema_dump
      if ENV['SEQUEL_SCHEMA']
        File.write(schema_path, schema_content)
      else
        IO.popen("pg_dump #{pg_options} #{pg_dump_options}", 'r') do |schema|
          IO.copy_stream(schema, schema_path)
        end
      end
    end

    def self.schema_load
      if ENV['SEQUEL_SCHEMA']
        Sequel.extension(:migration)
        require schema_path # migrate for the testdb
        Sequel::Migration.descendants.each do |mig|
          db.instance_eval(&mig.up)
        end
      else
        IO.popen("psql #{pg_options} > #{IO::NULL}", 'w') do |psql|
          IO.copy_stream(schema_path, psql)
        end
      end
    end

    def self.schema_content
      db.extension(:schema_dumper)
      db.dump_schema_migration
    end

    def self.schema_path
      path = "#{Something::ROOT}/lib/something/schema"
      if ENV['SEQUEL_SCHEMA']
        "#{path}.rb"
      else
        "#{path}.sql"
      end
    end

    def self.pg_options
      opts = []
      opts << "-h #{db.opts[:host]}" if db.opts[:host]
      opts << "-p #{db.opts[:port]}" if db.opts[:port]
      opts << "-U #{db.opts[:user]}" if db.opts[:user]
      opts << db.opts[:database]
      opts.join(' ')
    end

    def self.pg_dump_options
      "--schema-only --no-privileges"
    end

    def self.create_database d=database
      # we can't connect to the database we're going to create...
      Sequel.connect(db.opts.merge(:database => 'postgres')).
        run(%Q{CREATE DATABASE "#{d}"})
    rescue Sequel::DatabaseError => e
      warn e # ignore if database is already there
    end

    def self.drop_database d=database
      # we can't connect to the database we're going to drop...
      Sequel.connect(db.opts.merge(:database => 'postgres')).
        run(%Q{DROP DATABASE "#{d}"})
    rescue Sequel::DatabaseError => e
      warn e # ignore if database doesn't exist yet
    end

    # make sure testdb is up-to-date, recreate testdb with latest schema
    # and switch to the database
    def self.prepare_testdb
      unless ENV['DATABASE_URL'] # on CI there's only one database
        schema_dump
        testdb = "#{database}-test-api"
        drop_database(testdb)
        create_database(testdb)
        db.disconnect
        self.db = Sequel.connect(db.opts.merge(:database => testdb))
        self.db.extension :pg_array
        schema_load
      end
      %w[some materialized tables].each do |v|
        db.run("REFRESH MATERIALIZED VIEW #{v}")
      end
    end

    def self.delete_sensitive_data!
      db.run('SET statement_timeout TO 0;')
      Session.dataset.delete
      # ...
      db.run('VACUUM FULL;')
      db.run('SET statement_timeout TO 32500;')
    end

    def self.truncate_all_tables! tables=db.tables - [:schema_migrations]
      db.run("TRUNCATE #{tables.join(', ')} CASCADE")
    end

    def self.delete_all_tables! tables=db.tables - [:schema_migrations]
      query = tables.map{|t| "DELETE FROM #{t}"}
      db.run(query.join('; '))
    end
  end
end
