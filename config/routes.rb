Rails.application.routes.draw do
  devise_for :users

  root 'products#index'

  namespace :admin do
    resources :categories
  end

  resources :products
  
end
