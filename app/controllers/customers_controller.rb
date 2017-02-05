class CustomersController < ApplicationController
  before_action :set_customer, except: [:delete_all, :index, :create, :new, :update, :get_customers]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.search(params).get_json_customers
    respond_with(@customers) do |format|
      format.json { render :json => @customers.as_json }
      format.html
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    respond_with(@customer) do |format|
      format.json { render :json => @customer.get_json_customer_show.as_json }
      format.html
    end     
  end

  # GET /customers/new
  def new
    @user = User.new
    @user.build_customer
  end

  # GET /customers/1/edit
  def edit_form
    puts 'current_user',current_user.full_name
    respond_with(@customer) do |format|
      format.json { render :json => @customer.get_json_customer_edit.as_json }
      format.html
    end   
  end

  # POST /customers
  # POST /customers.json
  def create
    @user = User.new(customer_params)
    @user.customer.sales_user_id = current_user.id
    if @user.save
      render status: 200, json: { customer_id: @user.customer.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_customer_params)
      render status: 200, json: { customer_id: @user.customer.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    render json: {status: :ok}
  end

  def get_customers
    @users = User.sales_customers(current_user)
    respond_with(@users) do |format|
      format.json { render :json => User.get_json_customers_dropdown(@users) }
      format.html
    end  
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @customer = Customer.find(id.to_i)
        @customer.destroy
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_customer_params
      params.permit(:id,:password, :role, :first_name, :last_name, :email, customer_attributes:[:id, :customer_since, :user_id, :phone, :c_type, :street, :city, :state, :country, :postal_code, :decription, :created_at,:discount_percent, :credit_limit, :tax_reference, :payment_terms, :customer_currency,:created_at, :created_by_id, :updated_at, :updated_by_id])
    end

    def customer_params
      params[:customer][:role] = 'Customer'
      params[:customer][:password] = '12345678'
      params.require(:customer).permit(:id,:password, :role, :first_name, :last_name, :email, customer_attributes:[:id, :customer_since, :user_id, :phone, :c_type, :street, :city, :state, :country, :postal_code, :decription, :created_at,:discount_percent, :credit_limit, :tax_reference, :payment_terms, :customer_currency,:created_at, :created_by_id, :updated_at, :updated_by_id])
    end
end