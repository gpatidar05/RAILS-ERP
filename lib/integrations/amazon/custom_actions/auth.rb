module Integrations
  module Amazon
    module CustomActions
      module Auth

        def auth_connect
          if params[:merchant_id].blank? && params[:auth_token].blank?
            render template: :auth
          else
            @state[:merchant_id]  = params[:merchant_id]
            @state[:auth_token]  = params[:auth_token]
            redirect_url = integration_custom_action_url('auth_success_callback')
            redirect_to redirect_url
          end
        end

        def auth_success_callback
          redirect_to redirect_url_on_success
        end

      end
    end
  end
end