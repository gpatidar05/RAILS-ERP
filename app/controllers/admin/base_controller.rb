class Admin::BaseController < ApplicationController
  before_action :require_login,:admin_authentication
  layout 'admin'

end
