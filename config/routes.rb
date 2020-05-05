Rails.application.routes.draw do
  namespace :admin do
    get 'labels/index'
    get 'labels/new'
    get 'labels/edit'
  end
  root to: "sessions#new"
  resources :tasks
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
  namespace :admin do
    resources :users
  end
end
