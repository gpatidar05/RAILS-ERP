class User < ActiveRecord::Base
    #Has One Relationship
    has_one :customer, dependent: :destroy
    has_one :contact, dependent: :destroy
    has_one :supplier, dependent: :destroy
    has_one :employee, dependent: :destroy

    #Has Many Relationship
    has_many :accounts
    has_many :emails, dependent: :destroy

    #Devise Setting
    devise :multi_email_authenticatable, :registerable, :multi_email_confirmable,
             :recoverable, :rememberable, :trackable, :multi_email_validatable

    #Html Form Nested Attributes
    accepts_nested_attributes_for :customer
    accepts_nested_attributes_for :contact
    accepts_nested_attributes_for :supplier
    accepts_nested_attributes_for :employee

    after_create :create_default_accounts

    #validations
    # validates :first_name, :role, presence: true
    # validates :last_name, presence: true, unless: ->(user){user.Customer?}

    #constants
    ROLES = %w(Admin Sales Customer Contact Supplier Employee)

    #Included Module for the Create by and updated by user
    include SentientUser

    def full_name
        [self.first_name, self.middle_name, self.last_name].reject(&:blank?).join(' ')
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

    def Employee?
        self.role == 'Employee'
    end

    def self.sales_customers(current_user)
        joins(:customer).where("role IN (?)",["Customer"]).where("customers.sales_user_id = ? AND customers.is_active = ?",current_user.id,true)
    end

    def self.sales_contacts(current_user)
        joins(:contact).where("role IN (?)",["Contact"]).where("contacts.sales_user_id = ? AND contacts.is_active = ?",current_user.id,true)
    end

    def self.sales_employees(current_user)
        joins(:employee).where("role IN (?)",["Employee"]).where("employees.sales_user_id = ? AND employees.is_active = ?",current_user.id,true)
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

    def refresh_orders
        self.accounts.each {|account|
            next if account.state.blank?
            next unless account.integration.logged_in? rescue false
            SalesOrder.refresh_for_account(account)
        }
    end

    def self.get_json_customers_dropdown(users)
        list = []
        users.each do |user|
            list << as_json(only: [])
            .merge({name:user.full_name,
                customer_id:user.customer.id,
            })
        end
        return list
    end 

    def self.get_json_contacts_dropdown(users)
        list = []
        users.each do |user|
            list << as_json(only: [])
            .merge({name:user.full_name,
                contact_id:user.contact.id,
            })
        end
        return list
    end

    def self.get_json_staff_dropdown(users)
        list = []
        users.each do |user|
            list << as_json(only: [])
            .merge({name:user.full_name,
                id:user.id,
            })
        end
        return list
    end 

    def self.get_json_employees_dropdown(employees)
        list = []
        employees.each do |user|
            list << as_json(only: [])
            .merge({name:user.first_name,
                employee_id:user.employee.id,
            })
        end
        return list
    end

    private

        def create_default_accounts
            return false unless self.Sales?
            Marketplace.all.each { |marketplace|
                Account.create(:user_id => self.id, :title => marketplace.name, :marketplace_id => marketplace.id)
            }
        end

end
