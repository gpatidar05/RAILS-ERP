class ReportPayrollsController < ApplicationController
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  def index
    if params[:search_text].present?
        @payrolls = Payroll.search_box(params[:search_text],current_user.id).with_active.get_json_payrolls
    else
    	@payrolls = Payroll.report_search(params,current_user.id).with_active.get_json_payrolls
    end
    respond_with(@payrolls) do |format|
      format.json { render :json => @payrolls.as_json }
      format.html
    end
  end
end
