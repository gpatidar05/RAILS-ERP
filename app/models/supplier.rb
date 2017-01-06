class Supplier < ActiveRecord::Base

    belongs_to :user

    has_many :items, dependent: :destroy

    track_who_does_it

    #constants
    CURRENCY = %w(USD CAD AUD)
end
