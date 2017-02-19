class EmployeesController < ApplicationController
  before_action :set_employee, except: [:upload_photo, :get_employees, :delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /employees
  # GET /employees.json
  def index
    if params[:search_text].present?
      @employees = Employee.search_box(params[:search_text],current_user.id).with_active.get_json_employees
    else
      @employees = Employee.search(params,current_user.id).with_active.get_json_employees
    end
    respond_with(@employees) do |format|
      format.json { render :json => @employees.as_json }
      format.html
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    respond_with(@employee) do |format|
      format.json { render :json => @employee.get_json_employee.as_json }
      format.html
    end     
  end

  # POST /employees
  # POST /employees.json
  def create
    @user = User.new(employee_params)
    @user.employee.sales_user_id = current_user.id
    if @user.save
      render status: 200, json: { employee_id: @user.employee.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end 

  # GET /employees/edit_form/1.json
  def edit_form
    respond_with(@employee) do |format|
      format.json { render :json => @employee.get_json_employee_edit.as_json }
      format.html
    end   
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_employee_params)
      render status: 200, json: { employee_id: @user.employee.id}
    else
      render status: 200, :json => { message: @user.errors.full_messages.first }
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @employee = Employee.find(id.to_i)
        @employee.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  def get_employees
    @employees = User.sales_employees(current_user)
    respond_with(@employees) do |format|
      format.json { render :json => User.get_json_employees_dropdown(@employees) }
      format.html
    end  
  end

  def upload_photo
    uploader = AvatarUploader.new
    File.read(params[:file].tempfile.path) do |file|
      something = uploader.store!(file)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params = ActionController::Parameters.new(JSON.parse(request.POST[:employee]))
      params[:employee][:role] = 'Employee'
      params[:employee][:password] = '12345678'
      params[:employee][:employee_attributes][:photo] = request.POST['file']
      params.require(:employee).permit(:id,:email,:role,:password,:password_confirmation,:first_name,:last_name,:middle_name,
        employee_attributes:[:id, :salutation, :date_of_birth, :gender, :b_group, :nationality, :designation,
 			:department, :e_type, :work_shift, :reporting_person, :date_of_joining,
  			:allow_login, :religion, :marital_status, :mobile, :phone_office, :phone_home,
   			:permanent_address_street, :permanent_address_city, :permanent_address_state,
    		:permanent_address_postalcode, :permanent_address_country,
     		:resident_address_street, :resident_address_city, :resident_address_state,
      		:resident_address_postalcode, :resident_address_country,:photo])
    end
    def update_employee_params
      params = ActionController::Parameters.new(JSON.parse(request.POST[:employee]))
      params[:employee_attributes][:photo] = request.POST['file']
      params.permit(:id,:email,:first_name,:last_name,:middle_name,:password_confirmation,
        employee_attributes:[:id, :salutation, :date_of_birth, :gender, :b_group, :nationality, :designation,
 			:department, :e_type, :work_shift, :reporting_person, :date_of_joining,
  			:allow_login, :religion, :marital_status, :mobile, :phone_office, :phone_home,
   			:permanent_address_street, :permanent_address_city, :permanent_address_state,
    		:permanent_address_postalcode, :permanent_address_country,
     		:resident_address_street, :resident_address_city, :resident_address_state,
      		:resident_address_postalcode, :resident_address_country,:photo])
    end
end
