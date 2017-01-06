class PurchaseOrderItem < ActiveRecord::Base

    belongs_to :purchase_order
    belongs_to :item
    
end
