class CategoriesController < ApplicationController
  before_action :set_category, except: [:get_categories, :delete_all, :index, :create, :update, :get_customers]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /Categories
  # GET /Categories.json
  def index
    if params[:search_text].present?
      @categories = Category.search_box(params[:search_text],current_user.id).with_active.get_json_categories
    else
      @categories = Category.search(params,current_user.id).with_active.get_json_categories
    end
    respond_with(@categories) do |format|
      format.json { render :json => @categories.as_json }
      format.html
    end
  end

  # GET /Categories/1
  # GET /Categories/1.json
  def show
    respond_with(@category) do |format|
      format.json { render :json => @category.get_json_category.as_json }
      format.html
    end     
  end

  # POST /Categories
  # POST /Categories.json
  def create
    @category = Category.new(category_params)
    @category.sales_user_id = current_user.id
    if @category.save
      render status: 200, json: { category_id: @category.id}
    else
      render status: 200, :json => { message: @category.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /Categories/1
  # PATCH/PUT /Categories/1.json
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      render status: 200, json: { category_id: @category.id}
    else
      render status: 200, :json => { message: @category.errors.full_messages.first }
    end
  end

  # DELETE /Categories/1
  # DELETE /Categories/1.json
  def destroy
    @category.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @category = Category.find(id.to_i)
        @category.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_categories
    @categories = Category.sales_categories(current_user)
    respond_with(@categories) do |format|
      format.json { render :json => Category.get_json_categories_dropdown(@categories) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:id,:name, :unit, :tax, :manufacturer, :description)
    end
end
