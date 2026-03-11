class AccountHandler
  def initialize()
    @db = SQLite3::Database.new("db/database.db")
  end

  

  # profile handlers
  def create(name,password)
    @db.execute(
      "INSERT INTO account (name, password) VALUES (?, ?)",
      [name,password]
    )
  end
  def find(id)
    @db.execute(
      "SELECT profile WHERE id =?",
      [id]
    )
  end
end