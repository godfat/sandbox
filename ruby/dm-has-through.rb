
require 'dm-core'
require 'dm-migrations'

class Book
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  has n, :categories, :through => Resource
end

class Category
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  has n, :books, :through => Resource
end

DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.auto_migrate!
DataObjects::Sqlite3.logger = DataObjects::Logger.new($stdout, :debug)

ruby = Category.create(:name => 'Ruby')
# INSERT INTO "categories" ("name") VALUES ('Ruby')
java = Category.create(:name => 'Java')
# INSERT INTO "categories" ("name") VALUES ('Java')

Book.create(:name => 'Programming Ruby', :categories => [ruby])
# INSERT INTO "books" ("name") VALUES ('Programming Ruby')
# SELECT "book_id", "category_id" FROM "book_categories" WHERE ("book_id" = 1 AND "category_id" = 1) ORDER BY "book_id", "category_id" LIMIT 1
# INSERT INTO "book_categories" ("book_id", "category_id") VALUES (1, 1)

Book.create(:name => 'Programming Java', :categories => [java])
# INSERT INTO "books" ("name") VALUES ('Programming Java')
# SELECT "book_id", "category_id" FROM "book_categories" WHERE ("book_id" = 2 AND "category_id" = 2) ORDER BY "book_id", "category_id" LIMIT 1
# INSERT INTO "book_categories" ("book_id", "category_id") VALUES (2, 2)

p Book.all(:categories => Category.all(:name => 'Ruby') |
                          Category.all(:name => 'Java'))
# SELECT "id", "name" FROM "books" WHERE "id" IN (SELECT "id" FROM "categories" WHERE ("name" = 'Ruby' OR "name" = 'Java')) ORDER BY "id"
