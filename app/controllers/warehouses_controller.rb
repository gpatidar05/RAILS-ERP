class WarehousesController < ApplicationController
  before_action :set_warehouse, except: [:get_warehouses, :delete_all, :index, :create, :update, :get_customers]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /warehouses
  # GET /warehouses.json
  def index
    if params[:search_text].present?
      @warehouses = Warehouse.search_box(params[:search_text],current_user.id).with_active.get_json_warehouses
    else
      @warehouses = Warehouse.search(params,current_user.id).with_active.get_json_warehouses
    end
    respond_with(@warehouses) do |format|
      format.json { render :json => @warehouses.as_json }
      format.html
    end
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
    respond_with(@warehouse) do |format|
      format.json { render :json => @warehouse.get_json_warehouse.as_json }
      format.html
    end     
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @warehouse = Warehouse.new(warehouse_params)
    @warehouse.sales_user_id = current_user.id
    if @warehouse.save
      render status: 200, json: { warehouse_id: @warehouse.id}
    else
      render status: 200, :json => { message: @warehouse.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /warehouses/1
  # PATCH/PUT /warehouses/1.json
  def update
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.update_attributes(warehouse_params)
      render status: 200, json: { warehouse_id: @warehouse.id}
    else
      render status: 200, :json => { message: @warehouse.errors.full_messages.first }
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @warehouse = Warehouse.find(id.to_i)
        @warehouse.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_warehouses
    @warehouses = Warehouse.sales_warehouses(current_user)
    respond_with(@warehouses) do |format|
      format.json { render :json => Warehouse.get_json_warehouses_dropdown(@warehouses) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def warehouse_params
      params.require(:warehouse).permit(:id, :subject, :city, :province, :country, :description, :street, :postalcode)
    end
end

