class ManufacturingHistory < ActiveRecord::Base

    has_many :materials
    has_many :qa_check_lists
    belongs_to :sales_order
    belongs_to :manufacturing

    track_who_does_it

    scope :with_active, -> { where('is_active = ?', true) }

    def get_json_manufacturing
        sales_order_code = "SO-#{self.sales_order_id.to_s.rjust(4, '0')}" if self.sales_order.present?
        as_json(only: [:id, :subject, :description, :status, :m_type,
        	:quantity, :item_id, :sales_order_id, :start_date, :expected_completion_date])
        .merge({
        	code:"MFGH#{self.id.to_s.rjust(4, '0')}",
            sales_order:sales_order_code,
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_manufacturing_histories
        manufacturings_list =[]
        all.each do |manufacturing|
          manufacturings_list << manufacturing.get_json_manufacturing
        end
        return manufacturings_list
    end
end
