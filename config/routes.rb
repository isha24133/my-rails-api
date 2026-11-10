Rails.application.routes.draw do
  # 接続確認用（Base44 の ConnectionBanner がルートを ping します）
  root to: "api/health#show"
  get "up" => "api/health#show"

  namespace :api do
    resource :session, only: [:create]

    get "me", to: "users#me"
    resources :users, only: [:create, :update]

    resources :cafes, only: [:index, :show]
    resources :posts, only: [:index, :create]
    resources :tags, only: [:index]

    resources :want_cafes, only: [:index, :create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
end