Rails.application.routes.draw do
  get "/about", to: "about#index"
  resources :spots
  resources :sessions
  root "sessions#index"
end
