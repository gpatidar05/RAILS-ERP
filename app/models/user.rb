class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :lockable, :timeoutable and :omniauthable

    #Has One Relationship
    has_one :customer, dependent: :destroy
    has_one :contact, dependent: :destroy
    has_one :supplier, dependent: :destroy

    has_many :emails, dependent: :destroy
    has_many :sales_orders, dependent: :destroy
    has_many :purchase_orders, dependent: :destroy

    devise :multi_email_authenticatable, :registerable, :multi_email_confirmable,
             :recoverable, :rememberable, :trackable, :multi_email_validatable

    #Html Form Nested Attributes
    accepts_nested_attributes_for :customer
    accepts_nested_attributes_for :contact

    #validations
    validates :first_name, :role, presence: true
    validates :last_name, presence: true, unless: ->(user){user.Customer?}

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
  
    def self.sales_customers(current_user)
        joins(:customer).where("role IN (?)",["Customer"]).where("customers.sales_user_id = ?",current_user.id)
    end

    def self.sales_contacts(current_user)
        joins(:contact).where("role IN (?)",["Contact"]).where("contacts.sales_user_id = ?",current_user.id)
    end

    def self.sales_staff_users(current_user)
        user_ids = []
        user_ids << current_user.id if current_user.Sales?
        where("id IN (?)",user_ids)
    end

    def send_reset_password_instructions
        return false if self.Customer? or self.Contact?
        super
    end

end
