class ContactsController < ApplicationController
  before_action :set_contact, except: [:delete_all, :index, :create, :new, :update, :get_contacts]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /contacts
  # GET /contacts.json
  def index
    if params[:search_text].present?
      @contacts = Contact.search_box(params[:search_text],current_user.id).with_active.get_json_contacts
    else
      @contacts = Contact.search(params,current_user.id).with_active.get_json_contacts
    end
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
    @user.contact.sales_user_id = current_user.id
    if @user.save
      render status: 200, json: { contact_id: @user.contact.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end   

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_contact_params)
      render status: 200, json: { contact_id: @user.contact.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.update_attribute(:is_active, false)
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_contacts
    @users = User.sales_contacts(current_user)
    respond_with(@users) do |format|
      format.json { render :json => User.get_json_contacts_dropdown(@users) }
      format.html
    end  
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @contact = Contact.find(id.to_i)
        @contact.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
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
