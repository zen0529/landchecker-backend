class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authenticate_request!

  private

  def authenticate_request!
    token = extract_token
    raise ExceptionHandler::AuthenticationError, "Not authenticated" unless token

    decoded = JwtService.decode(token)
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::AuthenticationError, "User not found"
  end

  def extract_token
    auth_header = request.headers["Authorization"]
    auth_header&.split(" ")&.last
  end

  def current_user
    @current_user
  end
end