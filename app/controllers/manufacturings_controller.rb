class ManufacturingsController < ApplicationController
  before_action :set_manufacturing, except: [:add_material, :get_manufacturings, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /manufacturings
  # GET /manufacturings.json
  def index
    if params[:search_text].present?
      @manufacturings = Manufacturing.search_box(params[:search_text],current_user.id).with_active.get_json_manufacturings
    else
      @manufacturings = Manufacturing.search(params,current_user.id).with_active.get_json_manufacturings
    end
    respond_with(@manufacturings) do |format|
      format.json { render :json => @manufacturings.as_json }
      format.html
    end
  end

  # GET /manufacturings/1
  # GET /manufacturings/1.json
  def show
    respond_with(@manufacturing) do |format|
      format.json { render :json => @manufacturing.get_json_manufacturing.as_json }
      format.html
    end     
  end

  # POST /manufacturings
  # POST /manufacturings.json
  def create
    @manufacturing = Manufacturing.new(manufacturing_params)
    @manufacturing.sales_user_id = current_user.id
    if @manufacturing.save
      qa_check_list = JSON.parse(params[:manufacturing][:qa_check_list])
      qa_check_list.each do |check|
        passed = check['checked'].present? ? true : false
        QaCheckList.create(name:check['name'],passed:passed,manufacturing_id: @manufacturing.id)
      end
      render status: 200, json: { manufacturing_id: @manufacturing.id}
    else
      render status: 200, :json => { message: @manufacturing.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /manufacturings/1
  # PATCH/PUT /manufacturings/1.json
  def update
    @manufacturing = Manufacturing.find(params[:id])
    if @manufacturing.update_attributes(manufacturing_params)
      @manufacturing.qa_check_lists.delete_all
      qa_check_list = JSON.parse(params[:manufacturing][:qa_check_list])
      qa_check_list.each do |check|
        passed = check['passed'].present? ? true : false
        QaCheckList.create(name:check['name'],passed:passed,manufacturing_id: @manufacturing.id)
      end
      render status: 200, json: { manufacturing_id: @manufacturing.id}
    else
      render status: 200, :json => { message: @manufacturing.errors.full_messages.first }
    end
  end

  # DELETE /manufacturings/1
  # DELETE /manufacturings/1.json
  def destroy
    @manufacturing.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @manufacturing = Manufacturing.find(id.to_i)
        @manufacturing.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_manufacturings
    @manufacturings = Manufacturing.sales_manufacturings(current_user)
    respond_with(@manufacturings) do |format|
      format.json { render :json => Manufacturing.get_json_manufacturings_dropdown(@manufacturings) }
      format.html
    end  
  end

  def add_material
    @manufacturing_material = ManufacturingMaterial.new(manufacturing_material_params)
    if @manufacturing_material.save
      render status: 200, json: { manufacturing_material_id: @manufacturing_material.id}
    else
      render status: 200, :json => { message: @manufacturing_material.errors.full_messages.first }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manufacturing
      @manufacturing = Manufacturing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manufacturing_params
      params.require(:manufacturing).permit(:id, :subject, :description, :status,
       :m_type, :quantity, :item_id, :sales_order_id, :start_date, :expected_completion_date)
    end

    def manufacturing_material_params
      params.require(:manufacturing_material).permit(:id, :manufacturing_id, :material_id, :quantity, :total, :unit_price)
    end
end


