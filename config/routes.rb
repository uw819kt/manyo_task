Rails.application.routes.draw do
  # 一般ユーザー
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :labels, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  root to: 'sessions#new'
  
  # 管理者
  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
