class InvoicesController < ApplicationController
  	before_action :set_invoice, except: [:delete_all, :index]
  	respond_to :html, :json
  	skip_before_filter :verify_authenticity_token

	# GET /invoices
 	# GET /invoices.json
  	def index
      if params[:search_text].present?
        @invoices = Invoice.search_box(params[:search_text],current_user.id).get_json_invoices.get_json_expenses
      else
        @invoices = Invoice.search(params,current_user.id,false).with_active.get_json_invoices
      end
      	respond_with(@invoices) do |format|
        		format.json { render :json => @invoices.as_json }
        		format.html
    	end
  	end

  	# GET /invoices/1
  	# GET /invoices/1.json
  	def show
    	respond_with(@invoice) do |format|
      	format.json { render :json => @invoice.get_json_invoice_show.as_json }
      	format.html
    	end     
  	end

    def edit_form
      respond_with(@invoice) do |format|
        format.json { render :json => @invoice.get_json_invoice_edit.as_json }
        format.html
      end   
    end

    def update
      if @invoice.update_attributes(invoice_params)
        render status: 200, json: { invoice_id: @invoice.id}
      else
        render status: 200, :json => { message: @invoice.errors.full_messages.first }
      end
    end

    # DELETE /invoices/1
  	# DELETE /invoices/1.json
  	def destroy
      @invoice.update_attribute(:is_active, false)
    	render json: {status: :ok}
  	end

  	def delete_all
      	ids = JSON.parse(params[:ids])
      	ids.each do |id|
        	@invoice = Invoice.find(id.to_i)
          @invoice.update_attribute(:is_active, false)
      	end
      	render json: {status: :ok}
  	end

  	private
    	# Use callbacks to share common setup or constraints between actions.
    	def set_invoice
      		@invoice = Invoice.find(params[:id])
    	end

      def invoice_params
        params.require(:invoice).permit(:id, :customer_user_id, :contact_user_id)
      end

end
