require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

require_relative './Handlers/profileHandler.rb'

get("/") do
  slim(:index)
end
## Profile GET handlers
get("/profile/create") do 
  slim(:createProfile)
end

## Profile POST handlers
post("/profile/:id/create") do
  db = SQLite3::Database.new("db/database.db")
  name, gender, age = params[:name], params[:gender], params[:age]
  Profile.new(name,gender,age)
  slim(:index)
end