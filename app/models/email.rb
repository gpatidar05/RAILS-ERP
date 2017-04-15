class Email < ActiveRecord::Base
    #Belongs To Relationship
    belongs_to :user
end
