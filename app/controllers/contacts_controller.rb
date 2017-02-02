class ContactsController < ApplicationController
  before_action :set_contact, except: [:index, :create, :new, :update, :get_contacts]
  respond_to :html, :json
  protect_from_forgery

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.search(params).get_json_contacts
    respond_with(@contacts) do |format|
      format.json { render :json => @contacts.as_json }
      format.html
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    respond_with(@contact) do |format|
      format.json { render :json => @contact.get_json_contact_show.as_json }
      format.html
    end     
  end

  # GET /contacts/new
  def new
    @user = User.new
    @user.build_contact
  end

  # GET /contacts/edit_form/1.json
  def edit_form
    respond_with(@contact) do |format|
      format.json { render :json => @contact.get_json_contact_edit.as_json }
      format.html
    end   
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @user = User.new(contact_params)
    @user.contact.sales_user_id = User.find_by_email(params[:token]).id
    if @user.save
      render json: @user.as_json, status: :ok
    else
      render json: {user: @user.errors, status: :no_content}
    end
  end   

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_contact_params)
      render json: @user.as_json, status: :ok 
    else
      render json: {sales_order: @user.errors, status: :unprocessable_entity}
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_contacts
    @users = User.sales_contacts(User.find_by_email(params[:token]))
    respond_with(@users) do |format|
      format.json { render :json => User.get_json_contacts_dropdown(@users) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_contact_params
      params.permit(:id,:email,:role,:password,:first_name,:middle_name,:last_name,contact_attributes:[:id,:user_id,:customer_id,:salutation,:phone_mobile,:phone_work,:designation,:department,:primary_street,:primary_city,:primary_state,:primary_country,:primary_postal_code,:alternative_street,:alternative_city,:alternative_state,:alternative_country,:alternative_postal_code,:decription,:company, :created_at, :created_by_id, :updated_at, :updated_by_id])
    end

    def contact_params
      params[:contact][:role] = 'Contact'
      params[:contact][:password] = '12345678'
      params.require(:contact).permit(:id,:email,:role,:password,:first_name,:middle_name,:last_name,contact_attributes:[:id,:user_id,:customer_id,:salutation,:phone_mobile,:phone_work,:designation,:department,:primary_street,:primary_city,:primary_state,:primary_country,:primary_postal_code,:alternative_street,:alternative_city,:alternative_state,:alternative_country,:alternative_postal_code,:decription,:company, :created_at, :created_by_id, :updated_at, :updated_by_id])
    end
end
