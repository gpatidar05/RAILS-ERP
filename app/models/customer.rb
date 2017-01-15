class Customer < ActiveRecord::Base
    
    belongs_to :user
    
    has_many :contacts, dependent: :destroy

	validates :phone, :street, :city, :state, :country, :postal_code, :decription, presence: true

    track_who_does_it

    #constants
    TYPE = %w(Contractor Sales_Customer)

	def self.search(params)
	  search = all
	  search = search.where("customers.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
	  if params[:name].present?
	    name = params[:name].downcase
	    search = search.joins(:user)
	      .where("(((lower(users.first_name) || ' ' || lower(users.last_name)) LIKE ?) "\
	             'OR (lower(users.first_name) LIKE ?) OR (lower(users.last_name) LIKE ?))',\
	             "%#{name}%", "%#{name}%", "%#{name}%")
	  end
	  search = search.where('customers.phone = ?',params[:phone]) if params[:phone].present?
	  search = search.where('customers.country = ?',params[:country]) if params[:country].present?
	  search = search.where('customers.c_type IN (?)',params[:c_type]) if params[:c_type].present?
	  search = search.where('customers.created_by_id = ?',params[:created_by_id]) if params[:created_by_id].present?
	  search = search.where('DATE(customers.created_at) = ?', params[:created_at].to_date) if params[:created_at].present?
	  return search
	end

end
#created_by
