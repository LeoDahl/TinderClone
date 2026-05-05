require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute("PRAGMA foreign_keys = ON")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS likes (
    id INTEGER PRIMARY KEY,
    liker_id INTEGER NOT NULL,
    liked_id INTEGER NOT NULL,
    FOREIGN KEY (liker_id) REFERENCES account(id) ON DELETE CASCADE,
    FOREIGN KEY (liked_id) REFERENCES account(id) ON DELETE CASCADE
  );
SQL




