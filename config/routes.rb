Rails.application.routes.draw do

    resources :users, except: [] do
      collection do
        get 'get_users'
        get 'check_email'
        get 'logout'
        get 'email_confirmation'
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
        get 'delete_all'
      end
    end
    resources :notes, except: [] do
      collection do
        get 'delete_all'
      end
    end
    resources :contacts, except: [] do
      collection do
        get 'edit_form'
        get 'get_contacts'
        get 'delete_all'
      end
    end
    resources :sales_orders, except: [] do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'refresh'
        get 'get_sales_orders'
      end
    end
    resources :sales_order_invoices, except: [] do
      collection do
        get 'delete_all'
        get 'refresh'
        get 'edit_form'
        post 'create_invoice'
      end
    end
    resources :categories, except: [] do
      collection do
        get 'delete_all'
        get 'get_categories'
      end
    end
    resources :items, except: [] do
      collection do
        get 'delete_all'
      end
    end
    resources :suppliers, except: [] do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'get_suppliers'
      end
    end
    resources :purchase_orders, except: [] do
      collection do
        get 'edit_form'
        get 'delete_all'
      end
    end
    resources :accounts, except: [] do
      collection do
        get 'disconnect_account'
        get 'connect_account'
        get 'get_accounts'
      end
    end
    resources :employees, except: [] do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'get_employees'
        post 'upload_photo'
      end
    end
    resources :payrolls, except: [] do
      collection do
        get 'delete_all'
      end
    end
    resources :expenses, except: [] do
      collection do
        get 'delete_all'
      end
    end
    resources :timeclocks, except: [] do
      collection do
        get 'delete_all'
      end
    end
    resources :report_payrolls, only: [:index]
    resources :report_expenses, only: [:index]
end
 