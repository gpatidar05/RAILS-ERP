class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_headers

  include SentientController




  def set_headers
    puts 'ApplicationController.set_headers'
    if request.headers["HTTP_ORIGIN"]     
      headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
      headers['Access-Control-Expose-Headers'] = 'ETag'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
      headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
      headers['Access-Control-Max-Age'] = '86400'
      headers['Access-Control-Allow-Credentials'] = 'true'
    end
  end   


  private

  def after_sign_in_path_for(resource)
    session[:user_return_to] || stored_location_for(resource) || customers_path
  end

  def require_login
    redirect_to new_user_session_path if current_user.nil?
  end

  def admin_authentication
    redirect_to new_user_session_path if not current_user.admin?
  end

  def customer_authentication
    redirect_to new_user_session_path if not current_user.customer?
  end
end
