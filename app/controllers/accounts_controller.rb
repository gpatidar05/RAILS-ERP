class AccountsController < ApplicationController
  respond_to :html, :json

  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update_attributes(update_account_params)
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end

  def disconnect_account
    @account = current_user.accounts.find(params[:id])
    if @account.update_attribute(:state, nil) 
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end


  def connect_account
    @account = current_user.accounts.find(params[:id])
    if @account.update_attribute(:state, connect_state)
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end

  private
    def update_account_params
        params.permit(:auto_renew, relisting_pricing:[:unit, :operator, :value], sale_events_attributes:[[:start_date, :end_date, :id, :discount_percent, :item_category_id, :_destroy]]))
    end

    def connect_state
    	params.permit(:merchant_id,:auth_token).to_s
    end
end
