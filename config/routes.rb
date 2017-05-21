Rails.application.routes.draw do

    resources :users do
      collection do
        get 'get_users'
        get 'check_email'
        get 'logout'
        get 'email_confirmation'
      end
    end

    devise_for :users, path: 'auth_users', controllers: {
          sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords',confirmations: 'users/confirmations'
    }

    devise_scope :user do
      root :to => 'devise/sessions#new'
    end
    resources :customers do
      collection do
        get 'edit_form'
        get 'get_customers'
        get 'delete_all'
      end
    end
    resources :notes do
      collection do
        get 'delete_all'
      end
    end
    resources :contacts do
      collection do
        get 'edit_form'
        get 'get_contacts'
        get 'delete_all'
      end
    end
    resources :sales_orders do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'refresh'
        get 'get_sales_orders'
      end
    end
    resources :sales_order_invoices do
      collection do
        get 'delete_all'
        get 'refresh'
        get 'edit_form'
        post 'create_invoice'
        get 'get_sales_order_invoices'
      end
    end
    resources :categories do
      collection do
        get 'delete_all'
        get 'get_categories'
      end
    end
    resources :items do
      collection do
        get 'delete_all'
        get 'get_items'
      end
    end
    resources :suppliers do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'get_suppliers'
      end
    end
    resources :purchase_orders do
      collection do
        get 'edit_form'
        get 'delete_all'
        post 'add_item'
      end
    end
    resources :accounts do
      collection do
        get 'disconnect_account'
        get 'connect_account'
        get 'get_accounts'
        get 'get_marketplaces'
      end
    end
    resources :employees do
      collection do
        get 'edit_form'
        get 'delete_all'
        get 'get_employees'
        post 'upload_photo'
      end
    end
    resources :payrolls do
      collection do
        get 'delete_all'
      end
    end
    resources :expenses do
      collection do
        get 'delete_all'
      end
    end
    resources :timeclocks do
      collection do
        get 'delete_all'
      end
    end
    resources :report_payrolls, only: [:index]
    resources :report_expenses, only: [:index]
    resources :report_sales, only: [:index]
    resources :warehouses do
      collection do
        get 'delete_all'
        get 'get_warehouses'
      end
    end
    resources :warehouse_locations do
      collection do
        get 'delete_all'
        get 'get_warehouse_locations'
        post 'add_item'
      end
    end
    resources :manufacturings do
      collection do
        get 'delete_all'
        get 'get_manufacturings'
        post 'add_material'
      end
    end
    resources :materials do
      collection do
        get 'delete_all'
        get 'get_materials'
      end
    end
    resources :kb_categories do
      collection do
        get 'delete_all'
        get 'get_kb_categories'
      end
    end
    resources :knowledge_bases do
      collection do
        get 'delete_all'
        get 'get_knowledge_bases'
      end
    end
    resources :assets do
      collection do
        get 'delete_all'
        get 'get_assets'
      end
    end
    resources :maintanance_schedules do
      collection do
        get 'delete_all'
        get 'get_maintanance_schedules'
      end
    end
    resources :acc_accounts do
      collection do
        get 'delete_all'
        get 'get_acc_accounts'
      end
    end
    resources :ledger_entries do
      collection do
        get 'delete_all'
        get 'get_ledger_entries'
      end
    end
    resources :cheque_registers do
      collection do
        get 'delete_all'
      end
    end
    resources :return_wizards do
      collection do
        get 'delete_all'
        get 'get_return_wizards'
      end
    end
    resources :cash_flow_reports , only: [:index]


    
    # default integration custom actions paths
    match '/integration/:account_id/connect' => 'integration_custom_actions#auth_connect', as: :connect_integration, :via => [:get, :post]
    match '/integration/:account_id/:action' => 'integration_custom_actions#action_missing', as: :integration_custom_action_for_account, :via => [:get, :post]
    match '/integration/:action' => 'integration_custom_actions#action_missing', as: :integration_custom_action, :via => [:get, :post]

end
 