class Customer::BaseController < ApplicationController
  before_action :require_login,:customer_authentication
  layout 'customer'

end
