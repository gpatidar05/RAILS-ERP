json.extract! customer, :id, :user_id, :phone, :type, :street, :city, :state, :country, :postal_code, :decription, :created_at, :updated_at
json.url customer_url(customer, format: :json)