class ShopifyApp::Webhooks::OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :order_params, only:[:order_upadte_participant_chance]

    def order_upadte_participant_chance  
        @shop = get_shop
        if Customer.exists?(shopify_customer_id: order_params[:id].to_s)
            customer_update = Customer.find_by(shopify_customer_id: order_params[:id].to_s)
            customer_update.increment(:default_participant_chance, by = 1)
            customer_update.save
            head :ok
        end  
    end
  
    private

    def order_params
        params.require(:customer).permit(:id).to_h
    end
  
    def get_shop
        @shop = Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
    end
    
  end