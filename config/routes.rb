Rails.application.routes.draw do
  root to: 'posts#index'
  resources :users, except: [:new] do
    post 'relationship' => 'relationships#follow'
    delete 'relationship' => 'relationships#unfollow'
  end
  get 'signup' => 'users#new'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  get 'logout' => 'users#logout'

  resources :posts do
    resource :like, only: [:create, :destroy]
    post 'comment' => 'posts#comment'
  end
  
  resources :tags, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
