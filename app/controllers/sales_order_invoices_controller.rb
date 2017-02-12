class SalesOrderInvoicesController < ApplicationController
  	before_action :set_sales_order, except: [:refresh ,:delete_all, :index]
  	respond_to :html, :json
  	skip_before_filter :verify_authenticity_token

	# GET /sales_order_invoices
 	# GET /sales_order_invoices.json
  	def index
    	@sales_orders = SalesOrder.search(params,current_user.id,true).get_json_sales_orders
    	respond_with(@sales_orders) do |format|
      		format.json { render :json => @sales_orders.as_json }
      		format.html
    	end
  	end

  	# GET /sales_order_invoices/1
  	# GET /sales_order_invoices/1.json
  	def show
    	respond_with(@sales_order) do |format|
      	format.json { render :json => @sales_order.get_json_sales_order_show.as_json }
      	format.html
    	end     
  	end

    # DELETE /sales_order_invoices/1
  	# DELETE /sales_order_invoices/1.json
  	def destroy
    	@sales_order.destroy
    	render json: {status: :ok}
  	end

  	def delete_all
      	ids = JSON.parse(params[:ids])
      	ids.each do |id|
        	@sales_order = SalesOrder.find(id.to_i)
        	@sales_order.destroy
      	end
      	render json: {status: :ok}
  	end

    def refresh
      current_user.refresh_orders
    end

  	private
    	# Use callbacks to share common setup or constraints between actions.
    	def set_sales_order
      		@sales_order = SalesOrder.find(params[:id])
    	end
end
