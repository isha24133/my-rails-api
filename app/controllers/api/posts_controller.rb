module Api
  class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:create]

    # GET /api/posts?cafe_id=1&tag_id=2
    def index
      scope = Post.includes(:user, :cafe, :tags, :likes).order(created_at: :desc)

      scope = scope.where(cafe_id: params[:cafe_id]) if params[:cafe_id].present?

      if params[:tag_id].present?
        scope = scope.joins(:post_tags).where(post_tags: { tag_id: params[:tag_id] }).distinct
      end

      # 非公開の投稿は本人にだけ返します。
      scope =
        if current_user
          scope.where("visibility = ? OR user_id = ?", true, current_user.id)
        else
          scope.where(visibility: true)
        end

      render json: { posts: scope.map { |post| post.as_api_json(current_user) } }
    end

    # POST /api/posts
    def create
      post = current_user.posts.new(post_params)
      post.visibility = true if params.dig(:post, :visibility).nil?
      post.tags = Tag.where(id: tag_ids)

      if post.save
        render json: { post: post.as_api_json(current_user) }, status: :created
      else
        render json: { error: "validation_failed", errors: post.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:post).permit(:cafe_id, :visit_date, :content, :image, :visibility)
    end

    def tag_ids
      Array(params.dig(:post, :tag_ids)).map(&:to_i).reject(&:zero?).uniq
    end
  end
end