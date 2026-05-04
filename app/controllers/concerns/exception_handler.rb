module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class ExpiredToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
    rescue_from ExceptionHandler::ExpiredToken, with: :expired_token
    rescue_from ExceptionHandler::InvalidToken, with: :invalid_token
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
  end

  private

  def unauthorized(e)
    render json: { error: e.message }, status: :unauthorized
  end

  def expired_token(e)
    render json: { error: "Token has expired, please log in again" }, status: :unauthorized
  end

  def invalid_token(e)
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def unprocessable(e)
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end