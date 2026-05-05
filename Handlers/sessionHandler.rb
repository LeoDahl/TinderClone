require "bcrypt"
require_relative "accountHandler.rb"

class SessionHandler
  def initialize(session)
    @session = session
  end
  def is_user_logged_in?(logged_in_as, passhash)
    account_handler = AccountHandler.new()
    account_handler.match_credentials(logged_in_as, passhash) 
  end
  def create_session(username, encrypted_password, role)
    @session[:logged_in_as] = username
    @session[:accountsession] = encrypted_password
    @session[:role] = role
  end

end