require_relative "sessionHandler.rb"

class PictureHandler
  def initialize()
    @db = SQLite3::Database.new("db/database.db")
  end

  def get_images_from_account(id)
    @db.execute(
      "SELECT imageurl FROM imgprofile WHERE profileid = ?",
      [id]
    )
  end

end