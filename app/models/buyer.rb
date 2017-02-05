class Buyer < ActiveRecord::Base
	has_many :orders
	belongs_to :marketplace
	has_many :order_shipping_details

	validates_presence_of :uid
end
