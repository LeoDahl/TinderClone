require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

require_relative './Handlers/profileHandler.rb'
require_relative './Handlers/accountHandler.rb'
require_relative './Handlers/sessionHandler.rb'

enable :sessions



get("/") do
  sessionHandler = SessionHandler.new(session)

  passhash = session[:accountsession], 
  logged_in_as = session[:logged_in_as]
  p logged_in_as, passhash

  if passhash == nil or logged_in_as == nil
    p "hello"
    redirect("/account/login")
    return 
  end
  if sessionHandler.is_user_logged_in?(logged_in_as, passhash) == false 
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
  end
end


## Profile GET handlers
get("/profile/create") do 
  slim(:createProfile)
end

## Profile POST handlers
post("/profile/create") do
  profileHandler = ProfileHandler.new

  name, gender, age = params[:name], params[:gender], params[:age]
  profile_pic = params[:pfp]
  p "class : #{profile_pic}"
  store_profile_picture(profile_pic)

  profileHandler.create(name,gender,age)
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
end
