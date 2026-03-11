
require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS imgprofile (
  id INTEGER PRIMARY KEY,
  profileid INTEGER NOT NULL,
  imageurl TEXT NOT NULL
);
SQL

db.execute("DELETE FROM imgprofile")


# Image table
# Params : imageurl, id
#profileimg = [
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 1],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 2],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 3],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 4],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 5],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 6],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 7],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 8],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 9],
#  ["https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 10]
#]