
gem 'bson_ext'

require 'pg'
require 'mongo'
require 'benchmark'

class S
  def initialize
    @port = 5432
    @database = 'mongo'
    @conninfo = "host=localhost port=#{@port} dbname=#{@database}"
    @conn = PGconn.connect( @conninfo )
  end

  def exec sql
    @conn.exec(sql).to_a
  end

  def clear
    exec("DELETE from xlogs")
  end

  def read
    exec("SELECT id,message FROM xlogs LIMIT 5")
  end

  def write
    exec(%Q{INSERT INTO "xlogs" ("message") VALUES('xlog')})
  end

  def count
    exec("SELECT count(*) FROM xlogs")
  end
end

class M
  def initialize
    @conn = Mongo::Connection.new.db('mongo').collection('xlogs')
    @id = 0
  end

  def clear
    @conn.remove
  end

  def read
    @conn.find.limit(5).to_a
  end

  def write
    @id += 1
    @conn.insert('_id' => @id.to_s, 'message' => 'xlog')
  end

  def count
    @conn.count
  end
end

def postgres
  @postgres ||= S.new
end

def mongodb
  @mongodb ||= M.new
end

Benchmark.bmbm{ |x|
  postgres.clear
  mongodb.clear

  [:postgres, :mongodb].each{ |db|
    [:write, :read, :count].each{ |meth|
      x.report("#{db} #{meth}"){ 10000.times{ send(db).send(meth) } }
    }
  }
}
