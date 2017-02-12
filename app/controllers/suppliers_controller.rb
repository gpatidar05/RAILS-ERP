class SuppliersController < ApplicationController
  before_action :set_supplier, except: [:get_suppliers, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.search(params,current_user.id).with_active.get_json_suppliers
    respond_with(@suppliers) do |format|
      format.json { render :json => @suppliers.as_json }
      format.html
    end
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
    respond_with(@supplier) do |format|
      format.json { render :json => @supplier.get_json_supplier.as_json }
      format.html
    end     
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @user = User.new(supplier_params)
    @user.supplier.sales_user_id = current_user.id
    if @user.save
      render status: 200, json: { supplier_id: @user.supplier.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end 

  # GET /suppliers/edit_form/1.json
  def edit_form
    respond_with(@supplier) do |format|
      format.json { render :json => @supplier.get_json_supplier_edit.as_json }
      format.html
    end   
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_supplier_params)
      render status: 200, json: { supplier_id: @user.supplier.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @supplier = Supplier.find(id.to_i)
        @supplier.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_suppliers
    @suppliers = Supplier.sales_suppliers(current_user)
    respond_with(@suppliers) do |format|
      format.json { render :json => Supplier.get_json_suppliers_dropdown(@suppliers) }
      format.html
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params[:supplier][:role] = 'Supplier'
      params[:supplier][:password] = '12345678'
      params.require(:supplier).permit(:id,:email,:role,:password,:first_name,
        supplier_attributes:[:phone, :country, :supplier_currency,
      	:street, :city, :state, :postal_code, :supplier_since])
    end
    def update_supplier_params
      params.permit(:id,:email,:role,:password,:first_name,
        supplier_attributes:[:id,:phone, :country, :supplier_currency,
        :street, :city, :state, :postal_code, :supplier_since])
    end
end