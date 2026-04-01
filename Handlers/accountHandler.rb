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
  def get_id_from_username(username)
    @db.execute(
      "SELECT id FROM account WHERE username =?",
      [username]
    )
  end
  
  
  def match_credentials(username, password)
    user = @db.execute(
      "SELECT * FROM account WHERE username = ?",
      [username]
    ).first
    p user

    if user
      stored_hash = user[2]
      valid = BCrypt::Password.new(stored_hash)

      correct = valid == password
      return correct, stored_hash
    end  
    p "user not found"
    return false, nil
  end
  

  def encode(password)
    encrypted = BCrypt::Password.create(password)
    encrypted
  end
end