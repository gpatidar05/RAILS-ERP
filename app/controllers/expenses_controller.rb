class ExpensesController < ApplicationController
  before_action :set_expense, except: [:delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /expenses
  # GET /expenses.json
  def index
    if params[:search_text].present?
      @expenses = Expense.search_box(params[:search_text],current_user.id).with_active.get_json_expenses
    else
      @expenses = Expense.search(params,current_user.id).with_active.get_json_expenses
    end
    respond_with(@expenses) do |format|
      format.json { render :json => @expenses.as_json }
      format.html
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    respond_with(@expense) do |format|
      format.json { render :json => @expense.get_json_expense.as_json }
      format.html
    end     
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.sales_user_id = current_user.id
    if @expense.save
      render status: 200, json: { expense_id: @expense.id}
    else
      render status: 200, :json => { message: @expense.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    @expense = Expense.find(params[:id])
    if @expense.update_attributes(expense_params)
      render status: 200, json: { expense_id: @expense.id}
    else
      render status: 200, :json => { message: @expense.errors.full_messages.first }
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @expense = Expense.find(id.to_i)
        @expense.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:id,:subject, :employee_id, :amount,
       :status)
    end
end