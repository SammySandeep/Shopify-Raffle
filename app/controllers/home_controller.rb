# frozen_string_literal: true

class HomeController < AuthenticatedController
  layout 'application'
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
  def index

  end


end
