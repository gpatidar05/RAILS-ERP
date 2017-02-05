class SalesOrder < ActiveRecord::Base

    belongs_to :customer, class_name: "User", foreign_key: "customer_user_id"
    belongs_to :contact, class_name: "User", foreign_key: "contact_user_id"
  	belongs_to :account
  	belongs_to :buyer
  	belongs_to :order_shipping_detail
  	
  	has_many :sales_order_items, :dependent => :destroy

    track_who_does_it

    def self.refresh_for_account(account, date_from = 127.days.ago.to_date, date_to = DateTime.now.to_date)
	    orders = account.integration.get_orders(date_from.to_datetime, date_to.to_datetime)
	    puts orders
	    orders.each { |order|
	      	process_external_order(account, order.with_indifferent_access)
	    }
    end

    private
		def self.process_external_order(account, order)
		    if order_entry = account.sales_orders.find_by(:uid => order[:id])
		      	# update order
		      	SalesOrder.transaction do
			        # update/create Buyer record
			        buyer = order_entry.buyer
			        if (order[:buyer][:id] rescue false)
			          	buyer = account.marketplace.buyers.find_or_initialize_by(:uid => order[:buyer][:id])
			          	buyer.update_attributes!(order[:buyer].slice(:name, :email, :phone_number).select { |k, v| !v.blank? })
			        end
			        # update OrderShippingDetail record
			        unless order[:shipping].blank?
			          	if shipping_detail = order_entry.order_shipping_detail
			            	order_entry.order_shipping_detail.update_attributes!(order[:shipping].merge(:buyer_id => buyer.try(:id)))
			          	else
			            	shipping_detail = OrderShippingDetail.create!(order[:shipping].merge(:buyer_id => buyer.try(:id)))
			          	end
			        end
		        	# update Order record
		        	order_entry.update_attributes({
			                :buyer_id => buyer.try(:id),
			                :order_shipping_detail_id => shipping_detail.try(:id),
			                :update_timestamp => order[:last_update_at]
		            	}.merge({ 
			                :grand_total => order[:totals][:grandtotal],
			                :subtotal => order[:totals][:subtotal],
			                :discount => order[:totals][:discount],
			                :tax => order[:totals][:tax] 
			            }.select { |k, v| !v.blank? }
			   			).merge(order.slice(:payment_status,
                         	:paid_at, :refunded_at,
                         	:shipped, :shipped_at,
                         	:cancelled, :cancelled_at, :cancel_reason,
                         	:notes, :payment_method))
			   			)
		        	# TODO: update OrderListing records?
		      	end
		    else
		      	# create order
		      	SalesOrder.transaction do
			        # create/update Buyer record
			        if (order[:buyer][:id] rescue false)
			          	buyer = account.marketplace.buyers.find_or_initialize_by(:uid => order[:buyer][:id])
			          	buyer.update_attributes!(order[:buyer].slice(:name, :email, :phone_number).select { |k, v| !v.blank? })
			        end
			        # create OrderShippingDetail record
			        shipping_detail = OrderShippingDetail.create!(order[:shipping].merge(:buyer_id => buyer.try(:id))) unless order[:shipping].blank?
			        # create Order record
			        order_entry = account.sales_orders.create!({
	                        :buyer_id => buyer.try(:id),
	                        :order_shipping_detail_id => shipping_detail.try(:id),
	                        :uid => order[:id],
	                        :create_timestamp => order[:created_at],
	                        :update_timestamp => order[:last_update_at],
	                        :grand_total => order[:totals][:grandtotal],
	                        :subtotal => order[:totals][:subtotal],
	                        :discount => order[:totals][:discount],
	                        :tax => order[:totals][:tax],
		                }.merge(order.slice(
		                	:payment_status,
		                    :paid_at, :refunded_at,
		                    :shipped, :shipped_at,
		                    :cancelled, :cancelled_at, :cancel_reason,
		                    :notes, :payment_method))
		                )
			        # create OrderListing records
			        order[:items].each { |item|
			          	next if item[:item_id].blank? || (item[:quantity].try(:to_i) || 0) == 0
			          	# account_listing = account.account_listings.find_by(:uid => item[:item_id])
			          	# if (item[:price].try(:to_i) || 0) <= 0
				          #   if account_listing
				          #     	item[:price] = account_listing.price
				          #   else
				          #     	next
				          #   end
			          	# end
			          	order_entry.sales_order_items.create!(:uid => item[:item_id], :quantity => item[:quantity], :item_price => item[:price])
			        }
		      	end
		    end
		end
end
