class ShopifyApp::Webhooks::CustomersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :customer_params, only: %i[create update]
   
    def create_customer
      head :ok
      @shop = get_shop
      if Customer.exists?(shopify_customer_id: customer_params[:id].to_s)
      else
        Customer.create(
            shop_id: get_shop.id,
            shopify_customer_id: customer_params[:id],
            first_name: customer_params[:first_name],
            last_name: customer_params[:last_name],
            email_id: customer_params[:email]
          )
      end
    end

    def update_customer
      head :ok
      @customer = Customer.find_by(shopify_customer_id: customer_params[:id].to_s)
      @customer.first_name = customer_params[:first_name]
      @customer.last_name = customer_params[:last_name]
      @customer.email_id = customer_params[:email]
      @customer.save
    end

    def delete_customer
      head :ok
      @customer = Customer.find_by(shopify_customer_id: customer_params[:id].to_s)
      @customer.delete
    end
    
    def customer_params
      params.permit!
    end

    private
  
    def get_shop
      Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
    end
end  