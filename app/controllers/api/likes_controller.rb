module Api
  class LikesController < ApplicationController
    before_action :authenticate_user!

    # POST /api/likes  { "like": { "post_id": 1 } }
    def create
      post = Post.find(params.dig(:like, :post_id))
      like = current_user.likes.find_or_create_by(post: post)
      render json: { like: like.as_api_json }, status: :created
    end

    # DELETE /api/likes/:id
    def destroy
      like = current_user.likes.find(params[:id])
      like.destroy
      head :no_content
    end
  end
end