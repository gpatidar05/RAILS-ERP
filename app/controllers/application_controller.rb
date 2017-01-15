class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SentientController
  
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
