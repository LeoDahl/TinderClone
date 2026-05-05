require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute("PRAGMA foreign_keys = ON")
db.execute("DROP TABLE IF EXISTS profile")
db.execute <<-SQL
  CREATE TABLE profile (
    id INTEGER PRIMARY KEY,
    userid INTEGER NOT NULL,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    age INTEGER NOT NULL,

    FOREIGN KEY (userid) REFERENCES account(id)

  );
SQL

db.execute("DELETE FROM profile")
