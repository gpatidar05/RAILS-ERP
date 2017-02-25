class KbCategoriesController < ApplicationController
  before_action :set_kb_category, except: [:get_kb_categories, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /kb_categories
  # GET /kb_categories.json
  def index
    if params[:search_text].present?
      @kb_categories = KbCategory.search_box(params[:search_text],current_user.id).with_active.get_json_kb_categories
    else
      @kb_categories = KbCategory.search(params,current_user.id).with_active.get_json_kb_categories
    end
    respond_with(@kb_categories) do |format|
      format.json { render :json => @kb_categories.as_json }
      format.html
    end
  end

  # GET /kb_categories/1
  # GET /kb_categories/1.json
  def show
    respond_with(@kb_category) do |format|
      format.json { render :json => @kb_category.get_json_kb_category.as_json }
      format.html
    end     
  end

  # POST /kb_categories
  # POST /kb_categories.json
  def create
    @kb_category = KbCategory.new(kb_category_params)
    @kb_category.sales_user_id = current_user.id
    if @kb_category.save
      render status: 200, json: { kb_category_id: @kb_category.id}
    else
      render status: 200, :json => { message: @kb_category.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /kb_categories/1
  # PATCH/PUT /kb_categories/1.json
  def update
    @kb_category = KbCategory.find(params[:id])
    if @kb_category.update_attributes(kb_category_params)
      render status: 200, json: { kb_category_id: @kb_category.id}
    else
      render status: 200, :json => { message: @kb_category.errors.full_messages.first }
    end
  end

  # DELETE /kb_categories/1
  # DELETE /kb_categories/1.json
  def destroy
    @kb_category.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @kb_category = KbCategory.find(id.to_i)
        @kb_category.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_kb_categories
    @kb_categories = KbCategory.sales_kb_categories(current_user)
    respond_with(@kb_categories) do |format|
      format.json { render :json => KbCategory.get_json_kb_categories_dropdown(@kb_categories) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kb_category
      @kb_category = KbCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kb_category_params
      params.require(:kb_category).permit(:id, :name, :description)
    end
end
