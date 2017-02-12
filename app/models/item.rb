class Item < ActiveRecord::Base

    belongs_to :category
    belongs_to :supplier

    has_many :purchase_orders
    has_many :purchase_order_items
    has_many :item_images, dependent: :destroy

    track_who_does_it

    def self.search(params,current_user_id)
      search = where("items.sales_user_id = ?",current_user_id)
      search = search.where("items.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
      search = search.where('items.name = ?',params[:name]) if params[:name].present?
      search = search.where('items.category_id = ?',params[:category_id]) if params[:category_id].present?
      search = search.where('items.supplier_id = ?',params[:supplier_id]) if params[:supplier_id].present?
      return search
    end

    def get_json_item
        as_json(only: [:id,:name,:unit,:selling_price,:purchase_price,:item_description,
          :purchase_description, :selling_description, :tax, :item_in_stock,
          :max_level, :min_level,:category_id,:supplier_id])
        .merge({
        	code:"ITEM#{self.id.to_s.rjust(4, '0')}",
        	category: self.category.try(:name),
          supplier: self.supplier.try(:user).try(:full_name),
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_items
        items_list =[]
        all.each do |item|
          items_list << item.get_json_item
        end
        return items_list
    end
end