class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_login_params_exist, only: :create
  before_filter :login_required, only: :destroy
  respond_to :html, :json

  def create
    user = User.find_by_email(params[:user][:email])
    if user &&  user.valid_password?(params[:user][:password])
      # Device method to crete session and current_user
      #sign_in(:user, user)
      return render status: 200, json: user.as_json
    end
    return render status: 422, json: { error: "Invalid Credentials" }
  end

  def get_users
    @users = User.sales_staff_users(User.find_by_email(params[:token]))
    respond_with(@users) do |format|
      format.json { render :json => User.get_json_staff_dropdown(@users) }
      format.html
    end  
  end

  def destroy
    #signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(:user))
    render status: 200, json: { message: "Logged Out Successfully" }
  end

  private

  def ensure_login_params_exist
    return if !params[:user][:email].blank? and !params[:user][:password].blank?
    render status: 422, json: { error: "Missing Login params"}
  end
end