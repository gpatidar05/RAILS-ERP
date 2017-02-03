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

    def get_json_note_index
        as_json(only: [:id,:subject,:decription])
        .merge({
        	code:"NOTE#{self.id.to_s.rjust(4, '0')}",
        	contact:self.contact.try(:user).try(:full_name),
            customer:self.customer.try(:user).try(:full_name),
        	created_at:self.created_at.strftime('%d %B, %Y'),
        	created_by:self.creator.try(:full_name),
        	updated_at:self.updated_at.strftime('%d %B, %Y'),
        	updated_by:self.updater.try(:full_name),
        })
    end 

    def self.get_json_notes(is_notes_index=true, notes=[])
        notes = all if is_notes_index.present?
        notes_list =[]
        notes.each do |note|
          notes_list << note.get_json_note_index
        end
        return notes_list
    end

end
