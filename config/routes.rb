Rails.application.routes.draw do
  root to: "sessions#new"
  resources :tasks
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
end
