# Base44 のバックエンドからはサーバー間通信のため CORS は不要ですが、
# ブラウザから直接叩いて動作確認できるように許可しています。
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             max_age: 600
  end
end