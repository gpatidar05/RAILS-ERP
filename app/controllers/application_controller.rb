class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SentientController
  
  private
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
