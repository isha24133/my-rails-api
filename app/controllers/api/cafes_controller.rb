module Api
  class CafesController < ApplicationController
    # GET /api/cafes
    def index
      cafes = Cafe.includes(posts: { post_tags: :tag }).order(:id)
      render json: { cafes: cafes.map(&:as_api_json) }
    end

    # GET /api/cafes/:id
    def show
      cafe = Cafe.includes(posts: { post_tags: :tag }).find(params[:id])
      render json: { cafe: cafe.as_api_json }
    end
  end
end