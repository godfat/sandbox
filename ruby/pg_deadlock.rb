
# http://mina.naguib.ca/blog/2010/11/22/postgresql-foreign-key-deadlocks.html

# > pg_ctl --version
#   pg_ctl (PostgreSQL) 9.0.3

# > gem list pg
#   pg (0.10.1)

# > ruby -v
#   ruby 1.9.2p180 (2011-02-18 revision 30909) [x86_64-darwin10.6.0]

# > ruby ruby/pg_deadlock.rb
# ruby/pg_deadlock.rb:24:in `exec': ERROR:  deadlock detected (PGError)
# DETAIL:  Process 10549 waits for ShareLock on transaction 1711030; blocked by process 10550.
# Process 10550 waits for ExclusiveLock on tuple (0,5) of relation 290358 of database 289830; blocked by process 10549.
# HINT:  See server log for query details.
#         from ruby/pg_deadlock.rb:24:in `exec'
#         from ruby/pg_deadlock.rb:49:in `block in <main>'
#         from ruby/pg_deadlock.rb:42:in `fork'
#         from ruby/pg_deadlock.rb:42:in `<main>'

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
