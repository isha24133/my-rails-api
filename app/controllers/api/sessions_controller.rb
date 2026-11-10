module Api
  class SessionsController < ApplicationController
    # POST /api/session  { "mail": "...", "password": "..." }
    def create
      user = User.find_by(mail: params[:mail].to_s.strip.downcase)

      if user&.authenticate(params[:password].to_s)
        token = user.regenerate_api_token!
        render json: { token: token, user: user.as_api_json }
      else
        render json: {
          error: "invalid_credentials",
          message: "メールアドレスまたはパスワードが正しくありません。"
        }, status: :unauthorized
      end
    end
  end
end