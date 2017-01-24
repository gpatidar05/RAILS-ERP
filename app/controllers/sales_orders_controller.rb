class SalesOrdersController < ApplicationController
  before_action :set_sales_order, except: [:index, :create, :new]
  respond_to :html, :json
  protect_from_forgery with: :exception
  
  # GET /sales_orders
  # GET /sales_orders.json
  def index
    @sales_orders = SalesOrder.all
    respond_with(@sales_orders) do |format|
      format.json { render :json => @sales_orders.as_json }
      format.html
    end
  end

  # GET /sales_orders/1
  # GET /sales_orders/1.json
  def show
  end

  def show
    respond_with(@sales_order.as_json)
  end

  # GET /sales_orders/new
  def new
    @sales_order = SalesOrder.new
  end

  # GET /sales_orders/1/edit
  def edit
  end

  # POST /sales_orders
  # POST /sales_orders.json
  def create
    @sales_order = SalesOrder.new(sales_order_params)
    if @sales_order.save
      render json: @sales_order.as_json, status: :ok
    else
      render json: {sales_order: @sales_order.errors, status: :no_content}
    end
  end    

  # PATCH/PUT /sales_orders/1
  # PATCH/PUT /sales_orders/1.json

  def update
    if @sales_order.update_attributes(sales_order_params)
      render json: @sales_order.as_json, status: :ok 
    else
      render json: {sales_order: @sales_order.errors, status: :unprocessable_entity}
    end
  end

  # DELETE /sales_orders/1
  # DELETE /sales_orders/1.json
  def destroy
    @sales_order.destroy
    render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_order
      @sales_order = SalesOrder.find(params[:id])
      render json: {status: :not_found} unless @sales_order
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_order_params
      params.require(:sales_order).permit(:customer_user_id, :contact_user_id, :name, :subtotal, :tax, :grand_total, :created_by_id, :updated_by_id, :created_at, :updated_at)
    end
end
