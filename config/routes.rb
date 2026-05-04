Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      # Auth routes
      post   "auth/register", to: "auth#register"
      post   "auth/login",    to: "auth#login"
      delete "auth/logout",   to: "auth#logout"
      get    "auth/me",       to: "auth#me"

      # Properties routes
      resources :properties, only: [:index, :show]

      # Watchlist routes
      resources :watchlist_items, only: [:index, :create, :destroy, :update]

      # Saved searches routes
      resources :saved_searches, only: [:index, :create, :destroy]
    end
  end
end