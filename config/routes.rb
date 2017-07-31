Rails.application.routes.draw do

  resources :customers

  resources :orders

  resources :categories

  resources :goods

  devise_for :users

  resources :users

  root 'users#index'

  namespace "monitor" do
    resources "logs"
  end

  mount Ckeditor::Engine => '/ckeditor'

  namespace :interface do
    resources :wechat, only: [:index]

    resources :payments do
      collection do
        post :pay
        post :user_pay
        post :notify
      end
    end

    resources :goods do
      collection do
        get :get_goods
        get :goods_details
        post :buy
      end
    end
  end

end
