module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request!, only: [:register, :login]

      def register
        user = User.create!(user_params)
        token = JwtService.encode(user_id: user.id)
        render json: { token: token, user: user_data(user) }, status: :created
      end

      def login
        # user = User.find_by!(email: params[:email].downcase)
        user = User.find_by!(email: params.dig(:user, :email)&.downcase)
        raise ExceptionHandler::AuthenticationError, "Invalid credentials" unless user.authenticate(params.dig(:user, :password))

        token = JwtService.encode(user_id: user.id)
        render json: { token: token, user: user_data(user) }
      end

      def logout
        render json: { message: "Logged out successfully" }, status: :ok
      end

      def me
        render json: { user: user_data(current_user) }
      end

      private

      def user_params
        # params.permit(:email, :password, :first_name, :last_name)
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

      def user_data(user)
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name
        }
      end
    end
  end
end