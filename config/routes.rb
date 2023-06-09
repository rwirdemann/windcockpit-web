Rails.application.routes.draw do
  get "/about", to: "about#index"
  get "/friends", to: "friends#index"
  resources :spots
  resources :sessions
  resources :friends
  root "sessions#index"

  #  delete "/friends/:id", to: "friends#destroy"
  # post "friends", to: "friends#create"

  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  get "login", to: "user_sessions#new"
end
