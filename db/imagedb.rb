
require 'sqlite3'

db = SQLite3::Database.new("database.db")



db.execute <<-SQL
CREATE TABLE IF NOT EXISTS imgprofile (
  id INTEGER PRIMARY KEY,
  profileid INTEGER NOT NULL,
  imageurl TEXT NOT NULL,

  FOREIGN KEY (profileid) REFERENCES profile(id) ON DELETE CASCADE
);
SQL

db.execute("DELETE FROM imgprofile")


