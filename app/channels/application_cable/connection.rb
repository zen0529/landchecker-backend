module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = authenticate_user!
    end

    private

    def authenticate_user!
      token = extract_token
      raise ActionCable::Connection::Authorization::UnauthorizedError unless token

      payload = JwtService.decode(token)
      user    = User.find_by(id: payload[:user_id])

      reject_unauthorized_connection unless user
      user
    rescue JwtService::ExpiredToken, JwtService::InvalidToken
      reject_unauthorized_connection
    end

    def extract_token
      # The frontend sends the token in the WebSocket query string:
      # wss://example.com/cable?token=<jwt>
      request.params[:token].presence
    end
  end
end