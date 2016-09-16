Rails.application.routes.draw do

  root 'welcome#index'
  
  resources :survivors, only: [:edit, :new, :create, :update, :index]
  resources :complaints, only: [:new, :create]
  resources :trades, only: [:create]
end
