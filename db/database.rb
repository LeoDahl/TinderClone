require 'sqlite3'

db = SQLite3::Database.new("database.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS profile (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    age INTEGER NOT NULL
  );
SQL

db.execute("DELETE FROM profile")

# PROFILE TABLE EXAMPLE 
# Params : Name, male?, age
#users = [
#  ["Beo Bahl", true, 18],
#  ["Lucas poopson", true, 19],
#  ["Babisah goonson", false, 19],
#  ["Milo Anders", false, 19],
#  ["Sarina Kolt", true, 19],
#  ["Tobias Venn", true, 51],
#  ["Elina Marsh", false, 39],
#  ["Rico Dahlen", true, 29],
#  ["Nadia Frost", false, 19],
#  ["Oskar Lume", true, 19],
#]
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