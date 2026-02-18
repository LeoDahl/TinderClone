class Profile
  def initialize(name, gender, age)
    @name = name
    @gender = gender
    @age = age
    db = SQLite3::Database.new("db/database.db")
    db.execute("INSERT INTO profile (name,male,age) VALUES (?,?,?)", [@name,@gender,@age])
  end
  def get_profile_images

  end
end