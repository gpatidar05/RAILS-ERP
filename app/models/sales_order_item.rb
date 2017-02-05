class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_orders
end
