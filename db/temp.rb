require 'sqlite3'

db = SQLite3::Database.new("database.db")


db.execute("DELETE FROM profile")
db.execute("DELETE FROM profiles")
