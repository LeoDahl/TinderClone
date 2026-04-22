require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

require_relative './Handlers/profileHandler.rb'
require_relative './Handlers/accountHandler.rb'
require_relative './Handlers/sessionHandler.rb'
require_relative './Handlers/pictureHandler.rb'

enable :sessions



get("/") do
  sessionHandler = SessionHandler.new(session)

  passhash = session[:accountsession], 
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

## Account GET/POST Handlers

get("/account/create") do
  slim(:createAccount)
end
post("/account/create") do
  p "hi"
  username, password = params[:username], params[:password]
  accountHandler = AccountHandler.new

  accountHandler.create(username,username)

end
get("/account/login") do
  slim(:login)
end
post("/account/login") do
  sessionHandler = SessionHandler.new(session)
  p "account login post recieved"
  username, password = params[:username], params[:password]
  accountHandler = AccountHandler.new()
  valid, hash = accountHandler.match_credentials(username,password)
  if valid 
    sessionHandler.create_session(username, hash)
    redirect("/")
  else
    p "wrong pass"
  end
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

  @pics = pictureHandler.get_images_from_account(id)[0]
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
  redirect(:index)
end

post("/profile/:id/edit") do

end

post("/profile/:id/delete") do
  
end


def store_profile_picture(pic)
  random_name = ""
  8.times{random_name << ((rand(2)==1?65:97) + rand(25)).chr}

  path = "./images/profile_images/#{random_name}.jpg"
  File.open(path, "wb") do |file|
    file.write(pic["tempfile"].read)
  end
  return path
end
