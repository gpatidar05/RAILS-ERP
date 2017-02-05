class OrderShippingDetail < ActiveRecord::Base
  	has_one :sales_orders
  	belongs_to :buyer
end
