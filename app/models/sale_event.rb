class SaleEvent < ActiveRecord::Base

	belongs_to :category
	belongs_to :account

    def get_json_sale_event
        as_json(only: [:id,:account_id,:category_id,:start_date,:end_date,:discount_percent])
        .merge({
        	category: self.category.try(:name),
        })
    end 

    def self.get_json_sale_events
        sale_events_list =[]
        all.each do |sale_event|
          sale_events_list << sale_event.get_json_sale_event
        end
        return sale_events_list
    end

end
