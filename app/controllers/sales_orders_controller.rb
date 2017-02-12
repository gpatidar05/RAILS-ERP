class SalesOrdersController < ApplicationController
  	before_action :set_sales_order, except: [:refresh ,:delete_all, :index]
  	respond_to :html, :json
  	skip_before_filter :verify_authenticity_token

	# GET /sales_orders
 	# GET /sales_orders.json
  	def index
    	@sales_orders = SalesOrder.search(params,current_user.id,false).with_active.get_json_sales_orders
    	respond_with(@sales_orders) do |format|
      		format.json { render :json => @sales_orders.as_json }
      		format.html
    	end
  	end

  	# GET /sales_orders/1
  	# GET /sales_orders/1.json
  	def show
    	respond_with(@sales_order) do |format|
      	format.json { render :json => @sales_order.get_json_sales_order_show.as_json }
      	format.html
    	end     
  	end

    def edit_form
      respond_with(@sales_order) do |format|
        format.json { render :json => @sales_order.get_json_sales_order_edit.as_json }
        format.html
      end   
    end

    def update
      if @sales_order.update_attributes(sales_order_params)
        render status: 200, json: { sales_order_id: @sales_order.id}
      else
        render status: 200, :json => { message: @sales_order.errors.full_messages.first }
      end
    end

    # DELETE /sales_orders/1
  	# DELETE /sales_orders/1.json
  	def destroy
      @sales_order.update_attribute(:is_active, false)
    	render json: {status: :ok}
  	end

  	def delete_all
      	ids = JSON.parse(params[:ids])
      	ids.each do |id|
        	@sales_order = SalesOrder.find(id.to_i)
          @sales_order.update_attribute(:is_active, false)
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

      def sales_order_params
        params.require(:sales_order).permit(:id, :customer_user_id, :contact_user_id)
      end

end
