class WarehouseLocationsController < ApplicationController
  before_action :set_warehouse_location, except: [:add_item, :get_warehouse_locations, :delete_all, :index, :create, :update, :get_customers]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /warehouse_locations
  # GET /warehouse_locations.json
  def index
    if params[:search_text].present?
      @warehouse_locations = WarehouseLocation.search_box(params[:search_text],current_user.id).with_active.get_json_warehouse_locations
    else
      @warehouse_locations = WarehouseLocation.search(params,current_user.id).with_active.get_json_warehouse_locations
    end
    respond_with(@warehouse_locations) do |format|
      format.json { render :json => @warehouse_locations.as_json }
      format.html
    end
  end

  # GET /warehouse_locations/1
  # GET /warehouse_locations/1.json
  def show
    respond_with(@warehouse_location) do |format|
      format.json { render :json => @warehouse_location.get_json_warehouse_location.as_json }
      format.html
    end     
  end

  # POST /warehouse_locations
  # POST /warehouse_locations.json
  def create
    @warehouse_location = WarehouseLocation.new(warehouse_location_params)
    @warehouse_location.sales_user_id = current_user.id
    if @warehouse_location.save
      render status: 200, json: { warehouse_location_id: @warehouse_location.id}
    else
      render status: 200, :json => { message: @warehouse_location.errors.full_messages.first }
    end
  end 

  def add_item
    @warehouse_location_item = WarehouseLocationItem.new(warehouse_location_item_params)
    if @warehouse_location_item.save
      render status: 200, json: { warehouse_location_item_id: @warehouse_location_item.id}
    else
      render status: 200, :json => { message: @warehouse_location_item.errors.full_messages.first }
    end
  end

  # PATCH/PUT /warehouse_locations/1
  # PATCH/PUT /warehouse_locations/1.json
  def update
    @warehouse_location = WarehouseLocation.find(params[:id])
    if @warehouse_location.update_attributes(warehouse_location_params)
      render status: 200, json: { warehouse_location_id: @warehouse_location.id}
    else
      render status: 200, :json => { message: @warehouse_location.errors.full_messages.first }
    end
  end

  # DELETE /warehouse_locations/1
  # DELETE /warehouse_locations/1.json
  def destroy
    @warehouse_location.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @warehouse_location = WarehouseLocation.find(id.to_i)
        @warehouse_location.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_warehouse_locations
    @warehouse_locations = WarehouseLocation.sales_warehouse_locations(current_user)
    respond_with(@warehouse_locations) do |format|
      format.json { render :json => WarehouseLocation.get_json_warehouse_locations_dropdown(@warehouse_locations) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse_location
      @warehouse_location = WarehouseLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def warehouse_location_params
      params.require(:warehouse_location).permit(:id, :asset, :sku, :subject, :row_no, :warehouse_id, :status, :description, :rack_from, :rack_to)
    end

    def warehouse_location_item_params
      params.require(:warehouse_location_item).permit(:warehouse_location_id, :item_id)
    end

end
