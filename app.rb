require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

require_relative './Handlers/profileHandler.rb'
require_relative './Handlers/accountHandler.rb'
require_relative './Handlers/sessionHandler.rb'
require_relative './Handlers/pictureHandler.rb'

enable :sessions

LOGIN_ATTEMPT = {}

before do
  unless ["/account/login", "/account/create"].include?(request.path_info)
    if session[:logged_in_as].nil?
      redirect("/account/login")
    end
  end
end

get("/") do
  sessionHandler = SessionHandler.new(session)

  passhash = session[:accountsession]
  @logged_in_as = session[:logged_in_as]

  if passhash == nil or @logged_in_as == nil
    p "hello"
    redirect("/account/login")
    return 
  end
  if sessionHandler.is_user_logged_in?(@logged_in_as, passhash) == false 
    @logged_in_as = session[:logged_in_as]
    slim(:login)
  end
  slim(:index)
end

get('/swipe') do
  profileHandler = ProfileHandler.new()
  accountHandler = AccountHandler.new()
  pictureHandler = PictureHandler.new()

  @logged_in_as = session[:logged_in_as]

  p @logged_in_as
  id = accountHandler.get_id_from_username(@logged_in_as)[0][0]
  p id
  if id.nil? 
    slim(:createProfile)
  elsif profileHandler.find(id)
    selfprofile = profileHandler.find(id)
    p selfprofile
    selfName = selfprofile[0][2].to_s
    id = accountHandler.get_id_from_username(@logged_in_as)[0][0]
    print("selfname is = #{selfName}")

    @profiles = profileHandler.get_all_profiles_excluding(selfName)
    @randomuser = @profiles.sample()
    if pictureHandler.get_images_from_account(@randomuser[0])[0] != nil && pictureHandler.get_images_from_account(@randomuser[0])[0][0] != nil
      @pic = pictureHandler.get_images_from_account(@randomuser[0])[0][0]
    else
      @pic = "images/notFound.png"
    end

    @pic = @pic.gsub("public/", "")
    p "all other profiles = #{@profiles}"
    slim(:swipe)
  end
end

## Account GET/POST Handlers

get("/account/create") do
  slim(:createAccount)
end
post("/account/create") do
  p "hi"
  username, password, repeat = params[:username], params[:password], params[:repeat]
  if password != repeat
      @error = "repeat lösenord är fel"
  end
  if username.nil? || password.nil? || username.empty? || password.empty?
    @error = "Användarnamn eller lösenord kan inte vara tommaa"
    slim(:createAccount)
  else
    accountHandler = AccountHandler.new

    accountHandler.create(username,password)
    redirect("/account/login")
  end
end
get("/account/login") do
  slim(:login)
end
post("/account/login") do
  sessionHandler = SessionHandler.new(session)
  p "account login post recieved"
  username, password = params[:username], params[:password]
  
  if LOGIN_ATTEMPT[username] && Time.now - LOGIN_ATTEMPT[username] < 10
    @error =  "Vänta mellan varje försök"
    slim(:login)
  else
    accountHandler = AccountHandler.new()
    valid, hash = accountHandler.match_credentials(username,password)
    if valid 
      role = accountHandler.get_role(username)
      sessionHandler.create_session(username, hash, role)
      redirect("/")
    else
      @error = "fel lösenord"
      LOGIN_ATTEMPT[username] = Time.now
      slim(:login)
    end
end
end

get("/account/edit") do
  slim(:updatepass)
end
post("/account/updatepass") do 
  username = session[:logged_in_as]
  newpass = params[:new]
   p "username: #{username}"
  p "newpass: #{newpass}"
  accountHandler = AccountHandler.new()
  accountHandler.edit_password(username,newpass)
end

post("/logout") do
  session.clear()
  redirect("/account/login")
end

get("/profile") do
  profileHandler = ProfileHandler.new
  accountHandler = AccountHandler.new
  pictureHandler = PictureHandler.new

  logged_in_as = session[:logged_in_as]
  p logged_in_as
  id = accountHandler.get_id_from_username(logged_in_as)[0][0]
  @user = logged_in_as

  p id
  profile = profileHandler.find(id)[0]
  p "profile = #{profile}"

  @display = profile[2]
  @gender = profile[3]
  @age = profile[4]

  @pics = pictureHandler.get_images_from_account(id)[0] || []
  @pics = @pics.map {|pic| pic.gsub("public/", "")}
  p @pics
  slim(:profile)
end

## Profile GET handlers
get("/profile/create") do 
  slim(:createProfile)
end

## Profile POST handlers
post("/profile/create") do

  ## Get current logged in persons ID
  logged_in_as = session[:logged_in_as]
  accountHandler = AccountHandler.new()
  id = accountHandler.get_id_from_username(logged_in_as)[0]
  name, gender, age = params[:name], params[:gender], params[:age]
  profile_pic = params[:pfp]
  ###
  
  path = store_profile_picture(profile_pic)

  profileHandler = ProfileHandler.new
  p [path,id]
  profileHandler.add_profile_image(path, id)

  p "class : #{profile_pic}"

  profileHandler.create(id, name,gender,age)
  redirect("/")
end

post("/profile/:id/edit") do

end

post("/profile/:id/delete") do
  
end

post("/swipe/:id/like") do
  accountHandler = AccountHandler.new()
  liker_id = accountHandler.get_id_from_username(session[:logged_in_as])[0][0]
  liked_id = params[:id].to_i
  db = SQLite3::Database.new("db/database.db")

  ## hitta om redan finns
  existing = db.execute(
    "SELECT id FROM likes WHERE liker_id = ? AND liked_id = ?",
    [liker_id, liked_id]
  )
  if existing.empty?
      db.execute("INSERT INTO likes (liker_id, liked_id) VALUES (?, ?)",
      [liker_id, liked_id])
  end
  redirect("/swipe")
  
end

get("/matches") do
  accountHandler = AccountHandler.new()
  id = accountHandler.get_id_from_username(session[:logged_in_as])[0][0]
  db = SQLite3::Database.new("db/database.db")
  @matches = db.execute(
  "SELECT profile.name, profile.age, profile.gender
  FROM likes l1
  JOIN likes l2 ON l1.liker_id = l2.liked_id AND l1.liked_id = l2.liker_id
  JOIN profile ON profile.userid = l1.liked_id
  WHERE l1.liker_id = ?",
  [id]
  )
  slim(:likes)
end


## Admin stuffies

get("/admin") do
  if session[:role] != "admin"
    redirect("/")
  end
  db = SQLite3::Database.new("db/database.db")
  @accounts = db.execute("SELECT id, username, role FROM account")
  slim(:admin)
end

post("/admin/delete/:id") do
  if session[:role] != "admin"
    redirect("/")
  end
  db = SQLite3::Database.new("db/database.db")
  id = params[:id]
  db.execute("DELETE FROM account WHERE id = ?", [id])
end

def store_profile_picture(pic)
  random_name = ""
  8.times{random_name << ((rand(2)==1?65:97) + rand(25)).chr}

  path = "public/profile_images/#{random_name}.jpg"
  File.open(path, "wb") do |file|
    file.write(pic["tempfile"].read)
  end
  return path
end
