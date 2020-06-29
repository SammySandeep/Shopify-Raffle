# frozen_string_literal: true

class ShopifyApp::WebhooksController < ApplicationController
  include ShopifyApp::WebhookVerification
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :verify_webhook, raise: false

  def products_info
    @webhook_params = params.permit!
    head :ok
    @shop = shop_get
    if Product.find_by(shopify_product_id: params[:id]).nil?
      Product.create(
        shopify_product_id: params[:id],
        shopify_product_title: params[:title],
        has_variant: (params[:variants].count.positive? and params[:variants].first[:title] != 'Default Title'),
        shop_id: @shop.id
      )
      params[:variants].each do |variant|
        Raffle.create(
          title: 'PID' + params[:id].to_s + '-' + params[:title].gsub(' ', '') + '-VID' + variant[:id].to_s + '-' + variant[:title].gsub(' ', ''),
          shopify_product_id: params[:id],
          inventory: variant[:inventory_quantity],
          shop_id: @shop.id
        )
      end
    else
      @product = Product.find_by(shopify_product_id: params[:id])
      @product.shopify_product_id = params[:id]
      @product.shopify_product_title = params[:title]
      @product.has_variant = (params[:variants].count.positive? and params[:variants].first[:title] != 'Default Title')
      @product.save
      params[:variants].each do |variant|
        @title = Raffle.find_by(title: 'PID' + params[:id].to_s + '-' + params[:title].gsub(' ', '') + '-VID' + variant[:id].to_s + '-' + variant[:title].gsub(' ', ''))
        # Raffle.find_by(title: 'PID' + params[:id].to_s + '-' + params[:title].gsub(' ', '') + '-VID' + variant[:id].to_s + '-' + 'DefaultTitle')
        if @title.nil?
          Raffle.create(
            title: 'PID' + params[:id].to_s + '-' + params[:title].gsub(' ', '') + '-VID' + variant[:id].to_s + '-' + variant[:title].gsub(' ', ''),
            shopify_product_id: params[:id],
            inventory: variant[:inventory_quantity],
            shop_id: @shop.id
          )
        else
          @raffle = @title
          @raffle.shopify_product_id = params[:id]
          @raffle.inventory = variant[:inventory_quantity]
          @raffle.save
        end
      end
    end
  end

  private

  def shop_get
    Shop.find_by(shopify_domain: shop_domain)
  end
end
