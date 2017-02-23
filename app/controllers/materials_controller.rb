class MaterialsController < ApplicationController
  before_action :set_material, except: [:get_materials, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /materials
  # GET /materials.json
  def index
    if params[:search_text].present?
      @materials = Material.search_box(params[:search_text],current_user.id).with_active.get_json_materials
    else
      @materials = Material.search(params,current_user.id).with_active.get_json_materials
    end
    respond_with(@materials) do |format|
      format.json { render :json => @materials.as_json }
      format.html
    end
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
    respond_with(@material) do |format|
      format.json { render :json => @material.get_json_material.as_json }
      format.html
    end     
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)
    @material.sales_user_id = current_user.id
    if @material.save
      render status: 200, json: { material_id: @material.id}
    else
      render status: 200, :json => { message: @material.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    @material = Material.find(params[:id])
    if @material.update_attributes(material_params)
      render status: 200, json: { material_id: @material.id}
    else
      render status: 200, :json => { message: @material.errors.full_messages.first }
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @material = Material.find(id.to_i)
        @material.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_materials
    @materials = Material.sales_materials(current_user)
    respond_with(@materials) do |format|
      format.json { render :json => Material.get_json_materials_dropdown(@materials) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params.require(:material).permit(:id, :manufacturing_id, :name, :description, :unit, :quantity, :price)
    end
end


