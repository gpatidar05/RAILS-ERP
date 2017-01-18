Rails.application.routes.draw do

  resources :notes
  resources :contacts
  resources :customers
  devise_for :users, controllers: {
        sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords'
  }

  devise_scope :user do
   root :to => 'devise/sessions#new'
  end
  
  # Admin all routes
  namespace :admin do
    resources :dashboard, only: [:index]
  end

  # Customer all routes
  namespace :customer do
    resources :dashboard, only: [:index]
  end

end
