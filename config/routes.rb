Rails.application.routes.draw do
  root 'orders#index'
  
  resources :orders do 
    delete 'destroy_all', :on => :collection
  end

  resources :loads

end
