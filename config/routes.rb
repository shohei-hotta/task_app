Rails.application.routes.draw do
  get 'users/new'
  get 'users/show'
  root to: "tasks#index"
  resources :tasks
end
