class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  has_many :emails, dependent: :destroy
  has_one :customer, dependent: :destroy
  has_one :contact, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :orders, dependent: :destroy

  devise :multi_email_authenticatable, :registerable, :multi_email_confirmable,
         :recoverable, :rememberable, :trackable, :multi_email_validatable

  #validations
  validates :first_name, :last_name, :role, presence: true

  include SentientUser

  #constants
  ROLES = %w(Admin Sales Customer Contact)

  def admin?
    self.role == 'Admin'
  end

  def Sales?
    self.role == 'Sales'
  end

  def Customer?
    self.role == 'Customer'
  end

  def Contact?
    self.role == 'Contact'
  end
end
