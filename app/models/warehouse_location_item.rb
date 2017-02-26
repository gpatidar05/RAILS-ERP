class WarehouseLocationItem < ActiveRecord::Base

    belongs_to :warehouse_location
    belongs_to :item

    track_who_does_it

    def get_json_warehouse_location_item
        as_json(only: [:id, :warehouse_location_id, :item_id])
        .merge({
        	code:"ITEM#{self.id.to_s.rjust(4, '0')}",
          	name: self.item.try(:name),
          	item_in_stock: self.item.try(:item_in_stock),
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_warehouse_location_items
        warehouse_location_items_list =[]
        all.each do |warehouse_location_item|
          warehouse_location_items_list << warehouse_location_item.get_json_warehouse_location_item
        end
        return warehouse_location_items_list
    end
end
