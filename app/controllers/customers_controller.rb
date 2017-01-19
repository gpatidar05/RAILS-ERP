class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :destroy]
  layout 'customer'
  before_filter :require_login
  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.search(params).sales_customers(current_user).paginate(:per_page => 5, :page => params[:page])
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @user = User.new
    @user.build_customer
  end

  # GET /customers/1/edit
  def edit
    @user = User.find(@customer.user.id)
  end

  # POST /customers
  # POST /customers.json
  def create
    @user = User.new(customer_params)
    @user.customer.sales_user_id = current_user.id
    respond_to do |format|
      if @user.save
        format.html { redirect_to customer_path(@user.customer), notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(customer_params)
        format.html { redirect_to customer_path(@user.customer), notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @user = @customer.user
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
      @user = User.find(@customer.user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params[:user][:role] = 'Customer'
      params[:user][:password] = '12345678'
      params.require(:user).permit(:id,:password, :role, :first_name, :last_name, :email, customer_attributes:[:id, :user_id, :phone, :c_type, :street, :city, :state, :country, :postal_code, :decription, :created_at,:discount_percent, :credit_limit, :tax_reference, :payment_terms, :customer_currency,:created_at, :created_by_id, :updated_at, :updated_by_id])
    end
end