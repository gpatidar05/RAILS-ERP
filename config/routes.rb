Rails.application.routes.draw do

    resources :users, except: [] do
      collection do
        get 'get_users'
      end
    end

    devise_for :users, path: 'auth_users', controllers: {
          sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords'
    }

    devise_scope :user do
      root :to => 'devise/sessions#new'
    end

    resources :customers, except: [] do
      collection do
        get 'edit_form'
        get 'get_customers'
      end
    end

    resources :notes

    resources :contacts, except: [] do
      collection do
        get 'edit_form'
        get 'get_contacts'
      end
    end
end
