module Api
  class HealthController < ApplicationController
    def show
      render json: { status: "ok", service: "izumo-cafe-api", time: Time.current.iso8601 }
    end
  end
end