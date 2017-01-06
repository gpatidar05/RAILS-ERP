class PurchaseOrder < ActiveRecord::Base

    belongs_to :supplier, class_name: "User", foreign_key: "supplier_user_id"
    
    has_many :items
    has_many :purchase_order_items

    track_who_does_it

end
