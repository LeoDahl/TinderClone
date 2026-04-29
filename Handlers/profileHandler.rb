class ProfileHandler
  def initialize()
    @db = SQLite3::Database.new("db/database.db")
  end

  

  # profile handlers
  def create(id,name,gender,age)
    @db.execute(
      "INSERT INTO profile (userid, name, gender, age) VALUES (?, ?, ?, ?)",
      [id, name, gender, age]
    )
  end
  def find(id)
    @db.execute(
      "SELECT * FROM profile WHERE userid = ?",
      [id]
    )
  end
  def potential_matches(name,gender,age)

    min, max = calculate_age_range(age)
    opposite_gender = "MALE"
    if gender == "MALE"  
      opposite_gender = "FEMALE"
    else
      opposite_gender = "MALE"
    end

    @db.execute(
      "SELECT profile  WHERE age BETWEEN ? AND ? AND gender =?",
      [min,max, opposite_gender]
    )
  end

  # profile_images handlers
  def get_profile_images(id)
    db = SQLite3::Database.new("db/database.db")
    images = db.execute(
      "SELECT imageurl FROM imgprofile WHERE profile_id=?", 
      [id])
  end
  def add_profile_image(url, id)
    db = SQLite3::Database.new("db/database.db")
    db.execute(
      "INSERT INTO imgprofile (profileid, imageurl) VALUES (?,?)", 
      [id, url])
  end

  def get_all_profiles_excluding(name)
    db = SQLite3::Database.new("db/database.db")
    profile = db.execute(
      "SELECT * FROM profile WHERE name != ?",
      [name])
  end


  # private
  private
  def calculate_age_range(age)
    min = 0
    max = 0
    if age <= 21
      min = 18
    else age >= 22
      min = age - 4
    end
    max = age+4
    return [min,max]
  end

end