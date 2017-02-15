class ReportExpensesController < ApplicationController
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  def index
    @expenses = Expense.report_search(params,current_user.id).with_active.get_json_expenses
    respond_with(@expenses) do |format|
      format.json { render :json => @expenses.as_json }
      format.html
    end
  end
  
end
