class ItemsController < ApplicationController
  before_action :set_item, except: [:delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /items
  # GET /items.json
  def index
    if params[:search_text].present?
      @items = Item.search_box(params[:search_text],current_user.id).with_active.get_json_items
    else
      @items = Item.search(params,current_user.id).with_active.get_json_items
    end
    respond_with(@items) do |format|
      format.json { render :json => @items.as_json }
      format.html
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    respond_with(@item) do |format|
      format.json { render :json => @item.get_json_item.as_json }
      format.html
    end     
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.sales_user_id = current_user.id
    if @item.save
      render status: 200, json: { item_id: @item.id}
    else
      render status: 200, :json => { message: @item.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      render status: 200, json: { item_id: @item.id}
    else
      render status: 200, :json => { message: @item.errors.full_messages.first }
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @item = Item.find(id.to_i)
        @item.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:id, :name, :category_id, :supplier_id, :unit,
      	:tax, :item_in_stock, :max_level, :min_level, :selling_price, :purchase_price,
      	:item_description, :purchase_description, :selling_description)
    end

end
