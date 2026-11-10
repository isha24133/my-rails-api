require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module IzumoCafeApi
  class Application < Rails::Application
    config.load_defaults 7.1

    # JSON API のみを返す構成です。
    config.api_only = true

    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :utc

    # 画像は Base64 文字列で受け取るため、ログには出しません。
    config.filter_parameters += %i[password password_confirmation token api_token image profile_image]
  end
end