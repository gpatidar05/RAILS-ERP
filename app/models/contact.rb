class Contact < ActiveRecord::Base

    belongs_to :user
    belongs_to :customer

	validates :customer_id,:salutation,:phone_mobile,:phone_work,:designation,:department, presence: true
    track_who_does_it

    #constants
    SALUTATION = %w(Mr. Ms. Mrs. Prof. Dr.)

	def self.search(params)
	  search = all
	  if params[:code].present? 
	  	 code = params[:code].split("-CON")
	  	 if code.last.present?
	  	 	code = code.last.gsub(/\D/,'')
	  	 	search = search.where('contacts.id = ?', code)
	  	 end
	  end
	  search = search.joins(:user).where("lower(users.first_name) LIKE ?" ,"%#{params[:first_name].downcase}%") if params[:first_name].present?
	  search = search.joins(:user).where("lower(users.middle_name) LIKE ?" ,"%#{params[:middle_name].downcase}%") if params[:middle_name].present?
	  search = search.joins(:user).where("lower(users.last_name) LIKE ?" ,"%#{params[:last_name].downcase}%") if params[:last_name].present?
	  search = search.where('contacts.phone_mobile = ?', params[:mobile]) if params[:mobile].present?
	  search = search.where('(contacts.primary_country = ?) OR( contacts.alternative_country = ?)', params[:address_country],params[:address_country]) if params[:address_country].present?
	  search = search.where('contacts.designation = ?', params[:designation]) if params[:designation].present?
	  search = search.where('contacts.company = ?', params[:company]) if params[:company].present?
	  search = search.where('DATE(contacts.created_at) = ?', params[:created_at].to_date) if params[:created_at].present?
	  return search
	end
end
