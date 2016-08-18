Rails.application.routes.draw do
  resources :survivors, only: [:edit, :new, :create, :update, :index]
end
