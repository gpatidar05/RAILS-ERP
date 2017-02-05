class Marketplace < ActiveRecord::Base
  has_many :accounts
  has_many :buyers
end
