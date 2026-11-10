Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.log_tags = [:request_id]

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Render は TLS を前段で終端するため、アプリ側では強制しません。
  config.force_ssl = false

  config.active_record.dump_schema_after_migration = false

  # SECRET_KEY_BASE は環境変数から読み込みます（Render の Environment に設定してください）。
  config.secret_key_base = ENV["SECRET_KEY_BASE"] if ENV["SECRET_KEY_BASE"].present?

  # 大きな Base64 画像を扱うため、ログ出力は最小限にします。
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.logger.formatter = config.log_formatter
  config.logger.level = Logger.const_get(config.log_level.to_s.upcase)
end