class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  #validations
  validates :first_name,:last_name, presence: true

  #constants
  ROLES = %w(Admin Customer)

  def admin?
    self.role == 'Admin'
  end

  def customer?
    self.role == 'Customer'
  end

end
