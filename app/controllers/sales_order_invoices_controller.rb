class SalesOrderInvoicesController < ApplicationController
  	before_action :set_invoice, except: [:create_invoice, :create, :delete_all, :index]
  	respond_to :html, :json
  	skip_before_filter :verify_authenticity_token

  	def index
      if params[:search_text].present?
          @invoices = Invoice.search_box(params[:search_text],current_user.id).with_active.get_json_invoices
      else
          @invoices = Invoice.search(params,current_user.id,true).with_active.get_json_invoices
      end
    	respond_with(@invoices) do |format|
      		format.json { render :json => @invoices.as_json }
      		format.html
    	end
  	end

  	def show
    	respond_with(@invoice) do |format|
      	format.json { render :json => @invoice.get_json_invoice_show.as_json }
      	format.html
    	end     
  	end

  	def destroy
      @invoice.update_attribute(:is_active, false)
    	render json: {status: :ok}
  	end

    def update
      if @invoice.update_attributes(update_invoice_params)
        render status: 200, json: { invoice_id: @invoice.id}
      else
        render status: 200, :json => { message: @invoice.errors.full_messages.first }
      end
    end

    def create
      @invoice = Invoice.new(invoice_params)
      @invoice.sales_user_id = current_user.id
      if @invoice.save
        render status: 200, json: { invoice_id: @invoice.id}
      else
        render status: 200, :json => { message: @invoice.errors.full_messages.first }
      end
    end 

    def create_invoice
      @sales_order = SalesOrder.find(params[:id])
      @invoice = @sales_order.create_invoice
      unless @invoice.errors.present?
        render status: 200, json: { invoice_id: @invoice.id}
      else
        render status: 200, :json => { message: @invoice.errors.full_messages.first }
      end
    end 

  	def delete_all
      	ids = JSON.parse(params[:ids])
      	ids.each do |id|
        	@invoice = Invoice.find(id.to_i)
          @invoice.update_attribute(:is_active, false)
      	end
      	render json: {status: :ok}
  	end

    def edit_form
      respond_with(@invoice) do |format|
        format.json { render :json => @invoice.get_json_invoice_edit.as_json }
        format.html
      end   
    end
    
  	private
    	# Use callbacks to share common setup or constraints between actions.
    	def set_invoice
      		@invoice = Invoice.find(params[:id])
    	end

      def invoice_params
        params.require(:invoice).permit(:id,:customer_user_id,:contact_user_id,:sales_order_id,:name,:subtotal,
          :tax,:grand_total,:account_id,:uid,:buyer_id,:order_shipping_detail_id,
          :payment_status,:paid_at,:refunded_at,:shipped,:shipped_at,:cancelled,
          :cancelled_at,:cancel_reason,:notes,:payment_method,:create_timestamp,
          :update_timestamp,:discount,:marketplace_fee,:processing_fee,:status,
          :profit_share_deductions, :net, :acquisition_cost,
          order_shipping_detail_attributes:[:price,:name,:phone,:city,:state,:country,:postal_code,:address_line_1,
            :address_line_2,:carrier,:tracking_code,:tracking_url,:notes,:available_carriers,
            :buyer_id,:real_price],
          buyer_attributes:[:email,:uid,:name,:phone_number])
      end
      def update_invoice_params
        params.permit(:id,:customer_user_id,:contact_user_id,:sales_order_id,:name,:subtotal,
          :tax,:grand_total,:account_id,:uid,:buyer_id,:order_shipping_detail_id,
          :payment_status,:paid_at,:refunded_at,:shipped,:shipped_at,:cancelled,
          :cancelled_at,:cancel_reason,:notes,:payment_method,:create_timestamp,
          :update_timestamp,:discount,:marketplace_fee,:processing_fee,:status,
          :profit_share_deductions, :net, :acquisition_cost,
          order_shipping_detail_attributes:[:id,:price,:name,:phone,:city,:state,:country,:postal_code,:address_line_1,
            :address_line_2,:carrier,:tracking_code,:tracking_url,:notes,:available_carriers,
            :buyer_id,:real_price],
          buyer_attributes:[:id,:email,:uid,:name,:phone_number])
      end
end