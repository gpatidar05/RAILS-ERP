Rails.application.routes.draw do
  
  resources :sales_orders
  resources :notes
  resources :contacts
  resources :customers
  devise_for :users, controllers: {
        sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords'
  }

  devise_scope :user do
   root :to => 'devise/sessions#new'
  end
  
  get '*path' => 'angular#index'

end
