class KnowledgeBasesController < ApplicationController
  before_action :set_knowledge_base, except: [:get_knowledge_bases, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /knowledge_bases
  # GET /knowledge_bases.json
  def index
    if params[:search_text].present?
      @knowledge_bases = KnowledgeBase.search_box(params[:search_text],current_user.id).with_active.get_json_knowledge_bases
    else
      @knowledge_bases = KnowledgeBase.search(params,current_user.id).with_active.get_json_knowledge_bases
    end
    respond_with(@knowledge_bases) do |format|
      format.json { render :json => @knowledge_bases.as_json }
      format.html
    end
  end

  # GET /knowledge_bases/1
  # GET /knowledge_bases/1.json
  def show
    respond_with(@knowledge_base) do |format|
      format.json { render :json => @knowledge_base.get_json_knowledge_base.as_json }
      format.html
    end     
  end

  # POST /knowledge_bases
  # POST /knowledge_bases.json
  def create
    @knowledge_base = KnowledgeBase.new(knowledge_base_params)
    @knowledge_base.sales_user_id = current_user.id
    if @knowledge_base.save
      render status: 200, json: { knowledge_base_id: @knowledge_base.id}
    else
      render status: 200, :json => { message: @knowledge_base.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /knowledge_bases/1
  # PATCH/PUT /knowledge_bases/1.json
  def update
    @knowledge_base = KnowledgeBase.find(params[:id])
    if @knowledge_base.update_attributes(knowledge_base_params)
      render status: 200, json: { knowledge_base_id: @knowledge_base.id}
    else
      render status: 200, :json => { message: @knowledge_base.errors.full_messages.first }
    end
  end

  # DELETE /knowledge_bases/1
  # DELETE /knowledge_bases/1.json
  def destroy
    @knowledge_base.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @knowledge_base = KnowledgeBase.find(id.to_i)
        @knowledge_base.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_knowledge_bases
    @knowledge_bases = KnowledgeBase.sales_knowledge_bases(current_user)
    respond_with(@knowledge_bases) do |format|
      format.json { render :json => KnowledgeBase.get_json_knowledge_bases_dropdown(@knowledge_bases) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_base
      @knowledge_base = KnowledgeBase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def knowledge_base_params
      params.require(:knowledge_base).permit(:id, :title, :kb_category_id, :status, :revision,
			:body, :resolution, :author_id, :approver_id)
    end

end
