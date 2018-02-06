Rails.application.routes.draw do
  root 'loads#index'

  resources :users
  resources :sessions

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :loads do
    delete 'destroy_all', on: :collection
  end

  resources :orders
end
