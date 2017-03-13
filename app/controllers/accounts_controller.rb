class AccountsController < ApplicationController
  respond_to :html, :json

  def get_accounts
    @account = current_user.accounts
    render status: 200, json: { accounts: @account}
  end

  def get_marketplaces
    @marketplace = Marketplace.all
    render status: 200, json: { marketplace: @marketplace}
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end 

  def show
    @account = current_user.accounts.find(params[:id])
    respond_with(@account) do |format|
      format.json { render :json => @account.get_json_account }
      format.html
    end     
  end

  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update_attributes(update_account_params)
      if params[:sale_events_attributes].present?
        params[:sale_events_attributes].each do |sale_events|
          if sale_events[:id].blank? and sale_events[:is_delete] == false
            @account.sale_events.create(sale_events.permit(:category_id,:start_date,:end_date,:discount_percent))
          elsif sale_events[:id].present? and sale_events[:is_delete] == false
            @account.sale_events.find(sale_events[:id]).update_attributes(sale_events.permit(:category_id,:start_date,:end_date,:discount_percent))
          elsif sale_events[:id].present? and sale_events[:is_delete]
            @account.sale_events.find(sale_events[:id]).destroy
          end
        end
      end
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end

  def disconnect_account
    @account = current_user.accounts.find(params[:id])
    if @account.update_attribute(:state, nil)
      @account.is_connected = false
      @account.save()
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end


  def connect_account
    @account = current_user.accounts.find(params[:id])
    if @account.update_attribute(:state, connect_state)
      @account.is_connected = true
      @account.save()
      render status: 200, json: { account_id: @account.id}
    else
      render status: 200, :json => { message: @account.errors.full_messages.first }
    end
  end

  private
    def update_account_params
        params.require(:account).permit(:auto_renew, relisting_pricing:[:unit, :operator, :value])
    end

    def connect_state
    	params.permit(:merchant_id,:auth_token)
    end

    def account_params
      params = ActionController::Parameters.new(JSON.parse(request.POST[:marketplace]))
      params[:user_id] = current_user.id
      params[:title] = params[:name]
      params[:marketplace_id] = params[:id]
      params.permit(:user_id, :title ,:marketplace_id)
    end
end