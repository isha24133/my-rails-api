module Api
  class TagsController < ApplicationController
    # GET /api/tags
    def index
      render json: { tags: Tag.order(:id).map(&:as_api_json) }
    end
  end
end