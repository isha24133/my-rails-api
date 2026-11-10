class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def current_user
    return @current_user if defined?(@current_user)

    token = bearer_token
    @current_user = token.present? ? User.find_by(api_token: token) : nil
  end

  def authenticate_user!
    return if current_user

    render json: { error: "unauthorized", message: "ログインが必要です。" }, status: :unauthorized
  end

  def bearer_token
    header = request.headers["Authorization"].to_s
    header.start_with?("Bearer ") ? header.split(" ", 2).last.to_s.strip : nil
  end

  def render_not_found
    render json: { error: "not_found" }, status: :not_found
  end
end