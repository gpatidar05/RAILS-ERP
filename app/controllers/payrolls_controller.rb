class PayrollsController < ApplicationController
  before_action :set_payroll, except: [:delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /payrolls
  # GET /payrolls.json
  def index
    @payrolls = Payroll.search(params,current_user.id).with_active.get_json_payrolls
    respond_with(@payrolls) do |format|
      format.json { render :json => @payrolls.as_json }
      format.html
    end
  end

  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
    respond_with(@payroll) do |format|
      format.json { render :json => @payroll.get_json_payroll.as_json }
      format.html
    end     
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)
    @payroll.sales_user_id = current_user.id
    if @payroll.save
      render status: 200, json: { payroll_id: @payroll.id}
    else
      render status: 200, :json => { message: @payroll.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /payrolls/1
  # PATCH/PUT /payrolls/1.json
  def update
    @payroll = Payroll.find(params[:id])
    if @payroll.update_attributes(payroll_params)
      render status: 200, json: { payroll_id: @payroll.id}
    else
      render status: 200, :json => { message: @payroll.errors.full_messages.first }
    end
  end

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
  def destroy
    @payroll.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @payroll = Payroll.find(id.to_i)
        @payroll.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      params.require(:payroll).permit(:id,:subject, :employee_id, :base_pay,
       :allowances, :deductions, :expenses, :tax, :total)
    end
end
