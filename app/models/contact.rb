class Contact < ActiveRecord::Base
	belongs_to :user
	belongs_to :customer

	track_who_does_it

    #constants
    SALUTATION = %w(Mr. Ms. Mrs Prof. Dr.)
end
