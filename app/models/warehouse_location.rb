class WarehouseLocation < ActiveRecord::Base

    belongs_to :warehouse

    track_who_does_it

    scope :with_active, -> { where('is_active = ?', true) }

    def self.search_box(search_text,current_user_id)
      search = where("warehouse_locations.sales_user_id = ?",current_user_id)
      if !/\A\d+\z/.match(search_text)
        code = search_text.gsub(/\D/,'')
        if code.present?
            search = search.where(id: code.to_i)
        else
            search = search.where("subject LIKE :search OR status LIKE :search
                OR description LIKE :search", search: "%#{search_text}%")
        end
      else
        search = search.where("row_no = ? OR rack_from = ? OR rack_to = ?", search_text, search_text, search_text)
      end
      return search
    end

    def self.search(params,current_user_id)
        search = where("warehouse_locations.sales_user_id = ?",current_user_id)
        status = JSON.parse(params[:status]) if params[:status].present?
        search = search.where("warehouse_locations.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
        search = search.where('warehouse_locations.subject = ?',params[:subject]) if params[:subject].present?
        search = search.where('warehouse_locations.row_no = ?',params[:row_no]) if params[:row_no].present?
        search = search.where('warehouse_locations.warehouse_id = ?',params[:warehouse_id]) if params[:warehouse_id].present?
        search = search.where('warehouse_locations.status IN (?)',status) if status.present?
        search = search.where('warehouse_locations.description = ?',params[:description]) if params[:description].present?
        search = search.where('warehouse_locations.rack_from = ?',params[:rack_from]) if params[:rack_from].present?
        search = search.where('warehouse_locations.rack_to = ?',params[:rack_to]) if params[:rack_to].present?
        search = search.where('DATE(warehouse_locations.created_at) = ?', params[:created_at].to_date) if params[:created_at].present?
        search = search.where('warehouse_locations.created_by_id = ?',params[:created_by_id]) if params[:created_by_id].present?
        return search
    end

    def get_json_warehouse_location
        as_json(only: [:asset,:sku, :id,:subject, :row_no, :warehouse_id, :status, :description, :rack_from, :rack_to])
        .merge({
        	code:"WHL#{self.id.to_s.rjust(4, '0')}",
        	warehouse: self.warehouse.try(:subject),
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_warehouse_locations
        warehouse_locations_list =[]
        all.each do |warehouse|
          warehouse_locations_list << warehouse.get_json_warehouse_location
        end
        return warehouse_locations_list
    end

    def self.sales_warehouse_locations(current_user)
        where("warehouse_locations.sales_user_id = ? AND warehouse_locations.is_active = ?",current_user.id,true)
    end

    def self.get_json_warehouse_locations_dropdown(warehouse_locations)
        list = []
        warehouse_locations.each do |warehouse|
            list << as_json(only: [])
            .merge({name:warehouse.subject,
                warehouse_id:warehouse.id,
            })
        end
        return list
    end

end
