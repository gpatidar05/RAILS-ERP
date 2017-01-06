class Customer < ActiveRecord::Base
    
    belongs_to :user
    
    has_many :contacts, dependent: :destroy

    track_who_does_it

    #constants
    TYPE = %w(Contractor Sales_Customer)
end
