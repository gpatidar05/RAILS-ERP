class ReportPayrollsController < ApplicationController
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  def index
    @payrolls = Payroll.report_search(params,current_user.id).with_active.get_json_payrolls
    respond_with(@payrolls) do |format|
      format.json { render :json => @payrolls.as_json }
      format.html
    end
  end
end
