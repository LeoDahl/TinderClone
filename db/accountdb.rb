require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    pass TEXT NOT NULL
  );
SQL

db.execute("DELETE FROM account")

