class Category < ActiveRecord::Base

    has_many :items, dependent: :destroy

    track_who_does_it

    #constants
    UNIT = %w(Each Feet Kgs)
    TAX = %w(5 10 12 15 17)
end
