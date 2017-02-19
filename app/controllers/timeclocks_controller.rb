class TimeclocksController < ApplicationController
  before_action :set_timeclock, except: [:delete_all, :index, :create, :update]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /timeclocks
  # GET /timeclocks.json
  def index
    if params[:search_text].present?
      @timeclocks = Timeclock.search_box(params[:search_text],current_user.id).with_active.get_json_timeclocks
    else
      @timeclocks = Timeclock.search(params,current_user.id).with_active.get_json_timeclocks
    end
    respond_with(@timeclocks) do |format|
      format.json { render :json => @timeclocks.as_json }
      format.html
    end
  end

  # GET /timeclocks/1
  # GET /timeclocks/1.json
  def show
    respond_with(@timeclock) do |format|
      format.json { render :json => @timeclock.get_json_timeclock.as_json }
      format.html
    end     
  end

  # POST /timeclocks
  # POST /timeclocks.json
  def create
    @timeclock = Timeclock.new(timeclock_params)
    @timeclock.sales_user_id = current_user.id
    if @timeclock.save
      render status: 200, json: { timeclock_id: @timeclock.id}
    else
      render status: 200, :json => { message: @timeclock.errors.full_messages.first }
    end
  end 


  # PATCH/PUT /timeclocks/1
  # PATCH/PUT /timeclocks/1.json
  def update
    @timeclock = Timeclock.find(params[:id])
    if @timeclock.update_attributes(timeclock_params)
      render status: 200, json: { timeclock_id: @timeclock.id}
    else
      render status: 200, :json => { message: @timeclock.errors.full_messages.first }
    end
  end

  # DELETE /timeclocks/1
  # DELETE /timeclocks/1.json
  def destroy
    @timeclock.update_attribute(:is_active, false)
    render json: {status: :ok}
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @timeclock = Timeclock.find(id.to_i)
        @timeclock.update_attribute(:is_active, false)
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeclock
      @timeclock = Timeclock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timeclock_params
      params.require(:timeclock).permit(:id,:subject, :employee_id, :in_time,
       :out_time)
    end
end
