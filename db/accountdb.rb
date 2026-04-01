require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    pass TEXT NOT NULL,

    height, INTEGER,
    age, INTEGER,
    displayname, TEXT,
    gender, INTEGER, 
  );
SQL
## Male 1, Female 2, Other 3


db.execute("DELETE FROM account")

