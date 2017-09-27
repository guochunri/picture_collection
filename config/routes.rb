Rails.application.routes.draw do
  devise_for :users

  root 'products#index'

  namespace :admin do
    # 类型 #
    resources :category_groups do
      member do
        post :publish
        post :hide
      end
    end

    # 分类 #
    resources :categories do
      member do
        post :publish
        post :hide
      end
    end

    resources :products
    
  end

  resources :products

end
