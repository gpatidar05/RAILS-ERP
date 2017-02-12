class PurchaseOrder < ActiveRecord::Base

    belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_user_id"
    
    has_many :items
    has_many :purchase_order_items

    track_who_does_it

    def self.search(params,current_user_id)
      search = where("purchase_orders.sales_user_id = ?",current_user_id)
      search = search.where("purchase_orders.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
      search = search.where('purchase_orders.subject = ?',params[:subject]) if params[:subject].present?
      search = search.where('purchase_orders.total_price = ?',params[:total_price]) if params[:total_price].present?
      search = search.where('purchase_orders.supplier_user_id = ?',params[:supplier_user_id]) if params[:supplier_user_id].present?
      search = search.where('DATE(purchase_orders.created_at) = ?', params[:created_at].to_date) if params[:created_at].present?
      return search
    end

    def get_json_purchase_order
        as_json(only: [:id,:subject,:total_price,:sub_total,:tax,:grand_total,
        	:description,:supplier_user_id])
        .merge({
        	code:"ITEM#{self.id.to_s.rjust(4, '0')}",
          supplier: self.supplier.try(:user).try(:full_name),
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_purchase_orders
        purchase_orders_list =[]
        all.each do |purchase_order|
          purchase_orders_list << purchase_order.get_json_purchase_order
        end
        return purchase_orders_list
    end

    def get_json_purchase_order_edit
        as_json(only: [:id,:subject,:total_price,:sub_total,:tax,:grand_total,
          :description,:supplier_user_id])
    end 

    
end