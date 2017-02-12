class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, except: [:delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.search(params,current_user.id).with_active.get_json_purchase_orders
    respond_with(@purchase_orders) do |format|
      format.json { render :json => @purchase_orders.as_json }
      format.html
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
    respond_with(@purchase_order) do |format|
      format.json { render :json => @purchase_order.get_json_purchase_order.as_json }
      format.html
    end     
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.sales_user_id = current_user.id
    if @purchase_order.save
      render status: 200, json: { purchase_order_id: @purchase_order.id}
    else
      render status: 200, :json => { message: @purchase_order.errors.full_messages.first }
    end
  end 


  # GET /purchase_orders/edit_form/1.json
  def edit_form
    respond_with(@purchase_order) do |format|
      format.json { render :json => @purchase_order.get_json_purchase_order_edit.as_json }
      format.html
    end   
  end

  # PATCH/PUT /purchase_orders/1
  # PATCH/PUT /purchase_orders/1.json
  def update
    @purchase_order = PurchaseOrder.find(params[:id])
    if @purchase_order.update_attributes(purchase_order_params)
      render status: 200, json: { purchase_order_id: @purchase_order.id}
    else
      render status: 200, :json => { message: @purchase_order.errors.full_messages.first }
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @purchase_order = PurchaseOrder.find(id.to_i)
        @purchase_order.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_params
      params.require(:purchase_order).permit(:id,:subject,:total_price,:sub_total,
      	:tax,:grand_total,:description,:supplier_user_id)
    end
end
