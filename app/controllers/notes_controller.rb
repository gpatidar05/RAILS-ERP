class NotesController < ApplicationController
  before_action :set_note, except: [:delete_all, :index, :create, :new]
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.search(params).get_json_notes
    respond_with(@notes) do |format|
      format.json { render :json => @notes.as_json }
      format.html
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    respond_with(@note) do |format|
      format.json { render :json => @note.get_json_note_index.as_json }
      format.html
    end     
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    if @note.save
      render json: @note.as_json, status: :ok
    else
      render json: {note: @note.errors, status: :no_content}
    end
  end    

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update_attributes(note_params)
      render json: @note.as_json, status: :ok 
    else
      render json: {sales_order: @note.errors, status: :unprocessable_entity}
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_all
      ids = JSON.parse(params[:ids])
      ids.each do |id|
        @note = Note.find(id.to_i)
        @note.destroy
      end
      render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:id,:subject, :decription, :contact_id, :customer_id, :created_by_id, :updated_by_id, :created_at, :updated_at)
    end
end
