class Note < ActiveRecord::Base

    has_many :users_note
    has_many :users

    track_who_does_it
    
end
