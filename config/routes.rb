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

    resources :products do
      collection do
        get :search
      end
      member do
        get :download
        post :approve
        post :unapprove
        post :last_approved
        post :last_unapprove
      end
    end

  end

  resources :products

end
