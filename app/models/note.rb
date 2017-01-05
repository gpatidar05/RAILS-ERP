class Note < ActiveRecord::Base
	belongs_to :user
	
	track_who_does_it
end
