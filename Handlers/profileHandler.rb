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
      "SELECT * FROM profile WHERE age BETWEEN ? AND ? AND gender =?",
      [min,max, opposite_gender]
    )
  end

  # profile_images handlers
  def get_profile_images(id)
    images = @db.execute(
      "SELECT imageurl FROM imgprofile WHERE profileid=?", 
      [id])
  end
  def add_profile_image(url, id)
    @db.execute(
      "INSERT INTO imgprofile (profileid, imageurl) VALUES (?,?)", 
      [id, url])
  end

  def get_all_profiles_excluding(name)
    profile = @db.execute(
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
    elsif age >= 22
      min = age - 4
    end
    max = age+4
    return [min,max]
  end

end