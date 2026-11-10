module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, only: %i[me update]

    # POST /api/users  { "user": { username, mail, password, profile_image } }
    def create
      user = User.new(user_params)
      user.profile_image = params.dig(:user, :profile_image).presence

      if user.save
        render json: { user: user.as_api_json }, status: :created
      else
        render json: { error: "validation_failed", errors: user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    # GET /api/me
    def me
      render json: { user: current_user.as_api_json }
    end

    # PATCH /api/users/:id
    def update
      unless current_user.id == params[:id].to_i
        return render json: { error: "forbidden", message: "他のユーザーは編集できません。" },
                      status: :forbidden
      end

      if current_user.update(user_params)
        render json: { user: current_user.as_api_json }
      else
        render json: { error: "validation_failed", errors: current_user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :mail, :password, :profile_image)
    end
  end
end