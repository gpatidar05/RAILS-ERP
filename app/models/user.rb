class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :lockable, :timeoutable and :omniauthable

    has_one :customer, dependent: :destroy
    has_one :contact, dependent: :destroy
    has_one :supplier, dependent: :destroy

    has_many :emails, dependent: :destroy
    has_many :sales_orders, dependent: :destroy
    has_many :purchase_orders, dependent: :destroy
    has_many :notes, dependent: :destroy
    has_many :notes
    has_many :users_note

    devise :multi_email_authenticatable, :registerable, :multi_email_confirmable,
             :recoverable, :rememberable, :trackable, :multi_email_validatable

    #validations
    validates :first_name, :last_name, :role, presence: true

    #constants
    ROLES = %w(Admin Sales Customer Contact Supplier)

    include SentientUser

    def full_name
        [self.first_name, self.last_name].reject(&:blank?).join(' ')
    end

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

    def Supplier?
        self.role == 'Supplier'
    end
  
end
