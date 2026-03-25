require "bcrypt"
require_relative "sessionHandler.rb"

class AccountHandler
  include BCrypt
  def initialize()
    @db = SQLite3::Database.new("db/database.db")
  end

  # profile handlers
  def create(name,password)
    p "ran"
    encrypted = encode(password)
    @db.execute(
      "INSERT INTO account (username, pass) VALUES (?, ?)",
      [name,encrypted]
    )
  end
  def find(id)
    @db.execute(
      "SELECT account WHERE id =?",
      [id]
    )
  end
  
  
  def match_credentials(username, password)
    user = @db.execute(
      "SELECT * FROM account WHERE username = ?",
      [username]
    ).first
    p user

    stored_hash = user[2] 
    valid = BCrypt::Password.new(stored_hash)
    return valid, stored_hash
      
      
  end

  def encode(password)
    encrypted = BCrypt::Password.create(password)
    encrypted
  end
end