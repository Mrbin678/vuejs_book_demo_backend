Rails.application.routes.draw do

  namespace "monitor" do
    resources "logs"
  end

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users

  resources :users

  root 'users#index'

  namespace :interface do
    resources :wechat, only: [:index]

    resources :payments do
      collection do
        post :pay
        post :user_pay
        post :notify
      end
    end

  end

end
