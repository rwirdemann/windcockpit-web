Rails.application.routes.draw do
  get "/about", to: "about#index"
  get "/friends", to: "friends#index"
  resources :spots
  resources :sessions
  root "sessions#index"

  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  get "login", to: "user_sessions#new"
end
