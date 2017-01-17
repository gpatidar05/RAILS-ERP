class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :destroy]
  layout 'customer'
  before_filter :require_login
  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.search(params).sales_contacts(current_user).paginate(:per_page => 5, :page => params[:page])
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @user = User.new
    @user.build_contact
  end

  # GET /contacts/1/edit
  def edit
    @user = User.find(@contact.user.id)
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @user = User.new(contact_params)
    @user.contact.sales_user_id = current_user.id
    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_contact_path(@user.contact), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(contact_params)
        format.html { redirect_to contact_path(@user.contact), notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params[:user][:role] = 'Contact'
      params[:user][:password] = '12345678'
      params.require(:user).permit(:id,:email,:role,:password,:first_name,:middle_name,:last_name,contact_attributes:[:id,:user_id,:customer_id,:salutation,:phone_mobile,:phone_work,:designation,:department,:primary_street,:primary_city,:primary_state,:primary_country,:primary_postal_code,:alternative_street,:alternative_city,:alternative_state,:alternative_country,:alternative_postal_code,:decription,:company, :created_at, :created_by_id, :updated_at, :updated_by_id])
    end
end
