# frozen_string_literal: true

class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage
  # after_save :sync_data

  has_one :setting
  has_many :products
  has_many :raffles

  def api_version
    ShopifyApp.configuration.api_version
  end

  private

  def sync_data
    session_create
    sync_product
  end

  def session_create
    session = ShopifyAPI::Session.new(domain: shopify_domain, token: shopify_token, api_version: api_version)
    ShopifyAPI::Base.activate_session(session)
  end

  # def sync_product
  #   begin
  #     products = ShopifyAPI::Product.find(:all, params: { limit: 250 })
  #     products_array = []
  #     loop do
  #       products_array += products
  #       break unless products.next_page?

  #       products = products.fetch_next_page
  #     end
  #   rescue StandardError
  #     retry
  #   end
  #   products_array.each do |product|
  #     Product.create(
  #       shopify_product_title: product.title,
  #       shopify_product_id: product.id,
  #       has_variant: (product.variants.count.positive? and product.variants.first.title != 'Default Title'),
  #       shop_id: id
  #     )
  #     product.variants.each do |variant|
  #       Raffle.create(
  #         title: 'PID' + product.id.to_s + '-' + product.title.gsub(' ', '') + '-VID' + variant.id.to_s + '-' + variant.title.gsub(' ', ''),
  #         shopify_product_id: product.id,
  #         inventory: variant.inventory_quantity,
  #         shop_id: id
  #       )
  #     end
  #   end
  # end
end
