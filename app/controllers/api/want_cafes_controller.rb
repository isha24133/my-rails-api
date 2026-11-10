module Api
  class WantCafesController < ApplicationController
    before_action :authenticate_user!

    # GET /api/want_cafes
    def index
      render json: {
        want_cafes: current_user.want_cafes.order(created_at: :desc).map(&:as_api_json)
      }
    end

    # POST /api/want_cafes  { "want_cafe": { "cafe_id": 1 } }
    def create
      cafe = Cafe.find(params.dig(:want_cafe, :cafe_id))
      want_cafe = current_user.want_cafes.find_or_create_by(cafe: cafe)
      render json: { want_cafe: want_cafe.as_api_json }, status: :created
    end

    # DELETE /api/want_cafes/:id
    def destroy
      want_cafe = current_user.want_cafes.find(params[:id])
      want_cafe.destroy
      head :no_content
    end
  end
end