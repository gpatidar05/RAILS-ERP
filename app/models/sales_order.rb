class SalesOrder < ActiveRecord::Base

    belongs_to :customer, class_name: "User", foreign_key: "customer_user_id"
    belongs_to :contact, class_name: "User", foreign_key: "contact_user_id"

    track_who_does_it
    
end
