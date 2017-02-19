class ReportExpensesController < ApplicationController
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  def index
    if params[:search_text].present?
        @expenses = Expense.search_box(params[:search_text],current_user.id).with_active.get_json_expenses
    else
    	@expenses = Expense.report_search(params,current_user.id).with_active.get_json_expenses
    end
    respond_with(@expenses) do |format|
      format.json { render :json => @expenses.as_json }
      format.html
    end
  end
  
end
