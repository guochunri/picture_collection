Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  namespace :admin do
    resources :categories
  end

end
