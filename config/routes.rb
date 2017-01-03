Rails.application.routes.draw do

  devise_for :users, controllers: {
        sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords'
  }

  root 'landing#index'

  # Admin all routes
  namespace :admin do
    resources :dashboard, only: [:index]
  end

  # Customer all routes
  namespace :customer do
    resources :dashboard, only: [:index]
  end

end
