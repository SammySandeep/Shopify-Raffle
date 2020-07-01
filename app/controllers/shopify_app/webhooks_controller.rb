class ShopifyApp::WebhooksController < ApplicationController
  include ShopifyApp::WebhookVerification
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :verify_webhook, raise: false

  def products_info
    @webhook_params = params.permit!
    head :ok
    @shop = get_shop
  end

  def orders_info
    @webhook_params = params.permit!
    head :ok
    @shop = get_shop
    if Customer.exists?(shopify_customer_id: params[:customer][:id])
      customer = Customer.find_by(shopify_customer_id: params[:customer][:id])
      customer.increment(:default_participant_chance, by = 1)
      customer.save
    end  
  end

  private

  def get_shop
    Shop.find_by(shopify_domain: shop_domain)
  end

end