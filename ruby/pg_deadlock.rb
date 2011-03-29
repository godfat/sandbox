
# http://mina.naguib.ca/blog/2010/11/22/postgresql-foreign-key-deadlocks.html
require 'pg'

class Db
  def initialize database='friendmkt_test'
    @port = 5432
    @database = database
    @conninfo = "host=localhost port=#{@port} dbname=#{@database}"
    @conn = PGconn.connect( @conninfo )
  end

  def exec sql
    @conn.exec(sql).to_a
  end
end

# Db.new.exec(<<-SQL)
#   create table parents(
#     id serial not null primary key,
#     children_count integer not null default 0
#   );

#   create table children(
#     id serial not null primary key,
#     parent_id integer not null references parents(id)
#   );

#   insert into parents(id) values(1);
# SQL

pid = Process.fork do
  d0 = Db.new
  d0.exec(<<-SQL)
  begin;
    insert into children(parent_id) values(1);
  SQL
  sleep(0.5)
  d0.exec(<<-SQL)
    update parents set children_count=children_count + 1 where id=1;
  SQL
  sleep(0.5)
  d0.exec(<<-SQL)
    commit;
  SQL
end

if pid
  sleep(0.5)
  d1 = Db.new
  d1.exec(<<-SQL)
  begin;
    insert into children(parent_id) values(1);
  SQL
  sleep(0.5)
  d1.exec(<<-SQL)
    update parents set children_count=children_count + 1 where id=1;
  SQL
  sleep(0.5)
  d1.exec(<<-SQL)
    commit;
  SQL

  Process.wait
end
