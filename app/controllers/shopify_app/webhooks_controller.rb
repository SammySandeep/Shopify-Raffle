class ShopifyApp::WebhooksController < ApplicationController
  include ShopifyApp::WebhookVerification
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :verify_webhook, raise: false
 
  private

  def get_shop
    Shop.find_by(shopify_domain: shop_domain)
  end

  


end