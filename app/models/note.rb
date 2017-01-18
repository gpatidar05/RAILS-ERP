class Note < ActiveRecord::Base

	belongs_to :customer
	belongs_to :contact

	validates :subject, :decription, presence: true

    track_who_does_it

	def self.search(params)
	  search = all
	  search = search.where("notes.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
	  search = search.where('notes.subject = ?',params[:subject]) if params[:subject].present?
	  search = search.where('notes.customer_id = ?',params[:customer_id]) if params[:customer_id].present?
	  search = search.where('notes.contact_id = ?',params[:contact_id]) if params[:contact_id].present?
	  return search
	end

	def self.sales_notes(current_user)
		where("notes.sales_user_id = ?",current_user.id)
	end
    
end
