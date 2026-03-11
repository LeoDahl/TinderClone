require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

require_relative './Handlers/profileHandler.rb'
require_relative './Handlers/accountHandler.rb'


get("/") do
  slim(:index)
end

## Account GET/POST Handlers

get("/account/create") do
  slim(:createAccount)
end
post("/account/:id/create") do
  username, password = params[:username], params[:password]
  accountHandler = AccountHandler.new

  accountHandler.create(username,username)

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
  slim(:index)
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
